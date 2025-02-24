import 'dart:math';

class CropData {
  final double temperature;
  final double humidity;
  final double rainfall;
  final double ph;
  final double potassium;
  final double nitrogen;
  final double phosphorus;
  final String crop;

  CropData({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.ph,
    required this.potassium,
    required this.nitrogen,
    required this.phosphorus,
    required this.crop,
  });

  List<double> get features => [
    temperature,
    humidity,
    rainfall,
    ph,
    potassium,
    nitrogen,
    phosphorus,
  ];
}

class DecisionTree {
  final Random random;
  late Node root;
  final int maxDepth;
  final int minSamplesSplit;

  DecisionTree({
    required this.random,
    this.maxDepth = 10,
    this.minSamplesSplit = 2,
  });

  void train(List<CropData> data, List<int> featureIndices) {
    root = _buildTree(data, featureIndices, 0);
  }

  String predict(List<double> features) {
    return _traverse(root, features);
  }

  Node _buildTree(List<CropData> data, List<int> featureIndices, int depth) {
    if (depth >= maxDepth || data.length < minSamplesSplit) {
      return LeafNode(_getMajorityClass(data));
    }

    // Randomly select feature index for split
    int featureIndex = featureIndices[random.nextInt(featureIndices.length)];
    double splitValue = _findBestSplit(data, featureIndex);

    List<CropData> leftData = [];
    List<CropData> rightData = [];

    for (var item in data) {
      if (item.features[featureIndex] <= splitValue) {
        leftData.add(item);
      } else {
        rightData.add(item);
      }
    }

    if (leftData.isEmpty || rightData.isEmpty) {
      return LeafNode(_getMajorityClass(data));
    }

    return DecisionNode(
      featureIndex: featureIndex,
      splitValue: splitValue,
      left: _buildTree(leftData, featureIndices, depth + 1),
      right: _buildTree(rightData, featureIndices, depth + 1),
    );
  }

  double _findBestSplit(List<CropData> data, int featureIndex) {
    List<double> values = data.map((d) => d.features[featureIndex]).toList();
    values.sort();
    return values[values.length ~/ 2]; // Simple median split
  }

  String _getMajorityClass(List<CropData> data) {
    Map<String, int> classCounts = {};
    for (var item in data) {
      classCounts[item.crop] = (classCounts[item.crop] ?? 0) + 1;
    }
    return classCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String _traverse(Node node, List<double> features) {
    if (node is LeafNode) {
      return node.prediction;
    }
    
    node as DecisionNode;
    if (features[node.featureIndex] <= node.splitValue) {
      return _traverse(node.left, features);
    } else {
      return _traverse(node.right, features);
    }
  }
}

abstract class Node {}

class DecisionNode extends Node {
  final int featureIndex;
  final double splitValue;
  final Node left;
  final Node right;

  DecisionNode({
    required this.featureIndex,
    required this.splitValue,
    required this.left,
    required this.right,
  });
}

class LeafNode extends Node {
  final String prediction;

  LeafNode(this.prediction);
}

class RandomForest {
  final List<DecisionTree> trees;
  final int numTrees;
  final Random random;

  RandomForest({
    this.numTrees = 10,
    Random? random,
  }) : trees = [],
       random = random ?? Random();

  void train(List<CropData> dataset) {
    List<int> featureIndices = List.generate(7, (i) => i);

    for (int i = 0; i < numTrees; i++) {
      // Bootstrap sampling
      List<CropData> bootstrapSample = _getBootstrapSample(dataset);
      
      // Create and train decision tree
      var tree = DecisionTree(random: Random(random.nextInt(1000000)));
      tree.train(bootstrapSample, featureIndices);
      trees.add(tree);
    }
  }

  String predict(List<double> features) {
    // Get predictions from all trees
    List<String> predictions = trees.map((tree) => tree.predict(features)).toList();
    
    // Return majority vote
    Map<String, int> voteCounts = {};
    for (var prediction in predictions) {
      voteCounts[prediction] = (voteCounts[prediction] ?? 0) + 1;
    }
    
    return voteCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  List<CropData> _getBootstrapSample(List<CropData> dataset) {
    List<CropData> sample = [];
    int n = dataset.length;
    
    for (int i = 0; i < n; i++) {
      sample.add(dataset[random.nextInt(n)]);
    }
    
    return sample;
  }
}