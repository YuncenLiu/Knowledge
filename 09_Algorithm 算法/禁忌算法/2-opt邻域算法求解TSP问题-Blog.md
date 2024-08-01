# 2-opt邻域算法求解TSP问题

> 2-opt 算法：[百度百科](https://baike.baidu.com/item/2-opt/7766797)
>
> TSP 问题：[百度百科](https://baike.baidu.com/item/TSP%E9%97%AE%E9%A2%98)

## 问题概述

在考虑解决这个问题时，首先想到的是一种方法就是：列出每一条可供选择的路线（即对给定的仓库进行排列组合），计算出每条路线的总里程，最后从中选出一条最短路线，假设现在给定4个仓库分别为A、B、C和D各个仓库之间的耗费为已知数，如图一，可以通过一个组合的状态空间图表示左右组合如图2

![图1](https://xiang-1305498579.cos.ap-beijing.myqcloud.com/blog/images/202204211052540.png)

![图2](https://xiang-1305498579.cos.ap-beijing.myqcloud.com/blog/images/202204211052528.png)



## opt全领域搜索求解TSP思路

问题描述和模型构建

假设有9个仓库之间的距离如下图所示，求解其最短路径。

​                            表1 仓库之间的距离

| **仓库** | **A** | **B** | **C** | **D** | **E** | **F** | **G** | **H** | **I** |
| -------- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| **A**    | 0     | 20    | 13    | 14    | 8     | 13    | 34    | 8     | 24    |
| **B**    | 20    | 0     | 19    | 23    | 18    | 24    | 18    | 39    | 12    |
| **C**    | 13    | 19    | 0     | 16    | 26    | 28    | 14    | 9     | 33    |
| **D**    | 14    | 23    | 16    | 0     | 23    | 27    | 9     | 6     | 19    |
| **E**    | 8     | 18    | 26    | 23    | 0     | 30    | 27    | 16    | 5     |
| **F**    | 13    | 24    | 28    | 27    | 30    | 0     | 13    | 26    | 20    |
| **G**    | 34    | 18    | 14    | 9     | 27    | 13    | 0     | 19    | 21    |
| **H**    | 8     | 39    | 9     | 6     | 16    | 26    | 19    | 0     | 6     |
| **I**    | 24    | 12    | 33    | 19    | 5     | 20    | 21    | 6     | 0     |

 

 

全邻域搜索：

1、首先随机生成一个xnew，并令 xbest = xnew

2、根据一定规则【两点交换，3-opt，4-opt】产生xnew的全部领域解集N（xnew）

3、计算解集N（xnew）中每个解的值，将这些解中的最优解设定为xnow

4、如果xnow与xbest相同，则停止搜索执行步骤5，否则，若xnow优于xbest，则令xbest=xnow，令xnew=xnow，并将 xnew 的解向前随机移动一些位数，增加搜索能力，重复步骤2

5、输出最优解xbest

 具体实现

1、随机产生初始接xnew =[1 2 3 4 5]，f(xnew)=86，令xbest=xnew，f(best)=101

2、按照2-opt全邻域解集N(xnew),该解集N(xnew)中解的数量为 ![img](https://xiang-1305498579.cos.ap-beijing.myqcloud.com/blog/images/202204211052173.png) = ![img](https://xiang-1305498579.cos.ap-beijing.myqcloud.com/blog/images/202204211052937.png) = 6个【因为总是从城市1出发，所以后续城市先后变化关系只从2、3、4、5这四个城市中交换】,N（xnew)={[1 3 2 4 5], [1 4 3 2 5], [1 5 3 4 2], [1 2 4 3 5], [1 2 5 4 3], [1 2 3 5 4] }

3、计算N(xnew)中每个解的值，f(N(xnew))={86,75,93,93,90,102}，取其中最优解为 xnow，xnow=[1 4 3 2 5]

4、因为f(xnow)= 75<f(xbest)=86，所以 xbest=[1 4 3 2 5]，f(xbest)=75,令xnew=xnow=[1 4 3 2 5]，随机产生一个[1,4]区间的整数，假设是1，则xnew中后四为向前移动意味，变为xnew=[1 3 2 5 4]，继续步骤2

## Java实现

提示：easyopt 在 http://www.iescm.com/easyopt/ 中下载，并导入工程中

```java
package press.xiang;

// http://www.iescm.com/easyopt  中下载！
import easyopt.common.EasyMath;

import java.util.Arrays;

/**
 * Tsp 仓库路径求解
 * @author xiang
 * @version 1.0
 * @description: TODO
 * @date 2022/4/20 11:28 下午
 */
public class Tsp {

    /**
     * Some algorithms for optimizing warehouse problem(TSP'S)
     */
    public static void main(String[] args) {
        // step1: data initialization
        double[][] dist = {
                {0 ,20,13,14,8 ,13,34,8 ,24},
                {20,0 ,19,23,18,24,18,39,12},
                {13,19,0 ,16,26,28,14,9 ,33},
                {14,23,16,0 ,23,27,9 ,6 ,19},
                {8 ,18,26,23,0 ,30,27,16,5 },
                {13,24,28,27,30,0 ,13,26,20},
                {34,18,14,9 ,27,13,0 ,19,21},
                {8 ,39,9 ,6 ,16,26,19,0 ,6 },
                {24,12,33,19,5 ,20,21,6 ,0 }
        };
        // step2: create a solution and record the global
        int warehouse = dist.length;
        int[] xnow = new int[warehouse];
        for (int i = 0; i < warehouse; i++) {
            xnow[i] = i;
        }
        int[] xbest = new int[warehouse];
        xbest = Arrays.copyOf(xnow,warehouse);
        double fbest = getTspDist(dist,xbest);
        // update the solution until termination
        boolean notEnd = true;
        while (notEnd){
            // step3: create the neighborhood for the present solution- [2-opt]
            int[][] opt2 = EasyMath.combin2(warehouse - 1);
            int rows = opt2.length;
            int[][] cumbSolutions = new int[rows][warehouse];
            for (int i = 0; i < rows; i++) {
                cumbSolutions[i]=Arrays.copyOf(xnow,warehouse);
                int changePos1 = opt2[i][0]+1;
                int changePos2 = opt2[i][1]+1;
                cumbSolutions[i][changePos1] = xnow[changePos2];
                cumbSolutions[i][changePos2] = xnow[changePos1];
            }
            // 第一列是序号，第二列具体路径距离
            double[][] allDists = new double[rows][2];
            for (int i = 0; i < rows; i++) {
                allDists[i][1] = getTspDist(dist,cumbSolutions[i]);
                allDists[i][0] = i;
            }
            EasyMath.sortArray(allDists,new int[]{1});
            double nowFbest = allDists[0][1];
            // step4: update the best solution and whether algorithm is terminated
            if (nowFbest < fbest){
                fbest = nowFbest;
                xbest = cumbSolutions[(int)allDists[0][0]];
            }else{
                notEnd = false;
            }
            xnow = cumbSolutions[(int) allDists[0][0]];
            // 最优解偏移
            leftShift(xnow,(int)(Math.random()*warehouse));


        }// end of while
        System.out.println(" the optimal route: "+Arrays.toString(xbest));
        System.out.println(" the minimal distance: "+fbest);
    }


    /**
     * @description: 根据输入的仓库之间距离和调配路线，获取该路线的总长度
     * @param: dist 仓库之间的二维矩阵，行和列必须相等
     * @Param: route 调配路线经过各个仓库节点的孙旭，从0开始编号，0为起点和重点，必须为 route 的每一个值，后续的值不能相同
     * @return: double  返回总路程的长度，从节点0出发后每个仓库经过一次后返回节点0所需要的路径总长度
     * @author xiang
     * @date: 2022/4/21 9:11 上午
     */
    public static double getTspDist(double[][] dist,int[] route){
        double sumDist = 0;
        for (int i = 0; i < route.length -1; i++) {
            sumDist += dist[route[i]][route[i+1]];
        }
        sumDist+=dist[route[route.length-1]][0];
        return sumDist;
    }


    /**
     * 对一维数组向左偏移n个位数，不包括第一个数字
     * @description:
     * @param route tsp问题的第一条路径，第一个位置始终是0，只便宜了第一个位置以外的数字
     * @param n 向左便宜的位数
     * @return: void
     * @author xiang
     * @date: 2022/4/21 10:22 上午
     */
    public static void leftShift(int[] route,int n){
        int qty = route.length;
        if (n > qty - 1){
            n = qty - 2;
        }
        n = Math.max(1,n);
        for (int i = 0; i < n; i++) {
            int firstVal = route[1];
            for (int j = 1; j < qty -1; j++) {
                route[j] = route[j+1];
            }
            route[qty-1]=firstVal;
        }
    }
}
```

求解得：

![image-20220421105011046](https://xiang-1305498579.cos.ap-beijing.myqcloud.com/blog/images/202204211052053.png)