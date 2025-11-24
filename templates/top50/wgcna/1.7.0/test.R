# 加载WGCNA库
library(WGCNA)

# 设置随机种子以便结果可复现
set.seed(123)

# 创建一个100个样本和50个基因的随机表达矩阵
randomData <- matrix(rnorm(100 * 50), nrow = 100, ncol = 50)
rownames(randomData) <- paste0("Sample", 1:100)
colnames(randomData) <- paste0("Gene", 1:50)

# 模拟样本特征（例如疾病状态）
sampleTraits <- data.frame(Trait1 = rbinom(100, 1, 0.5))
rownames(sampleTraits) <- rownames(randomData)

# 进行软阈值选择
powers = c(c(1:10), seq(from = 12, to = 20, by = 2))
sft = pickSoftThreshold(randomData, powerVector = powers, verbose = 5)

# 显示软阈值选择的结果
print(sft$fitIndex)

# 绘制软阈值选择的结果图
sizeGrWindow(9, 5)
par(mfrow = c(1,2));
cex1 = 0.9;
# Scale-free topology fit index as a function of the soft-thresholding power
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)", ylab="Scale Free Topology Model Fit, signed R^2", 
     type="n", main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], labels=powers, cex=cex1,
     col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.80, col="red")
# Mean connectivity as a function of the soft-thresholding power
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)", ylab="Mean Connectivity", 
     type="n", main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1, col="red")

# 构建邻接矩阵
softPower = 6  # 假设选择了软幂为6，具体数值取决于你的数据和软阈值选择结果
adjacency = adjacency(randomData, power = softPower)

# 转换为拓扑重叠矩阵 (TOM)
TOM = TOMsimilarity(adjacency)

# 计算 dissTOM
dissTOM = 1 - TOM

# 使用动态树切割算法进行模块检测
moduleColors = cutreeDynamic(dendro = hclust(as.dist(dissTOM)), minClusterSize = 30)

# 绘制模块颜色条
table(moduleColors)
plotDendroAndColors(dendro = hclust(as.dist(dissTOM)), colors = moduleColors, colorLabels = "Module Colors")

# 计算模块特征基因 (MEs)
MEs = moduleEigengenes(randomData, moduleColors)$eigengenes

# 关联模块与样本特征
moduleTraitSignificance = as.data.frame(cor(MEs, sampleTraits, use = "p"))
moduleTraitPvalues = as.data.frame(corPvalueStudent(as.matrix(moduleTraitSignificance), nSamples = nrow(randomData)))

# 显示模块-样本特征关联
print(moduleTraitSignificance)
print(moduleTraitPvalues)
