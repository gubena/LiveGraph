# LiveGraph
LiveGraph is a Processing class that displays in real-time a dynamic graph that allows receiving an indefinite amount of data.
This is because when the amount of data becomes longer than the window, the graph will shift to always show the most recent values.
It also allows you to show several curves simultaneously, in which they all share the X-axis (time).

![](https://github.com/gubena/LiveGraph/blob/main/images/image_2023-09-08_112540403.png)


Most of its parameters are definable variables so you can customize its appearance and behavior to suit different applications.

**Constructor:**
- _LiveGraph(float x, float y, float windowWidth, float windowHeight, PApplet window, int numOfChannels)_


**Functions:**
- _void setAxisProperties(float tMax, float yMin, float yMax, float timeIncrement, String yUnit)_
- _void setGraphProperties(color backgroundColor, color lineColor, float lineThickness)_
- _void setGridProperties(float tGridIncrement, float yGridIncrement, color gridColor)_
- _void setTextProperties(float textSize, int decimalPlaces, String title, float titleSize, String[] channelNames, color textColor)_
- _void addPoint(float num)_
- _void addPoint(float[] nums)_
- _void resetData()_
- _void export(String tableName)_
- _void display()_

![](https://github.com/gubena/LiveGraph/blob/main/images/image_2023-09-08_112611164.png)
