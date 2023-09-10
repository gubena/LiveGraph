# LiveGraph
LiveGraph is a Processing class that displays in real-time a dynamic graph that allows receiving an indefinite amount of data.
This is because when the amount of data becomes longer than the window, the graph will shift to always show the most recent values.
It also allows you to show several curves simultaneously, in which they all share the X-axis (time).
<p align="center">
  <img src="https://github.com/gubena/LiveGraph/blob/main/images/image_2023-09-08_112540403.png" />
</p>

Most of its parameters are definable variables so you can customize its appearance and behavior to suit different applications.

**Constructor:**
<br /> LiveGraph (float x, float y, float windowWidth, float windowHeight, PApplet window, int numOfChannels)


**Functions:**
<br /> void setAxisProperties(float tMax, float yMin, float yMax, float timeIncrement, String yUnit)
<br /> void setGraphProperties(color backgroundColor, color lineColor, float lineThickness)
<br /> void setGridProperties(float tGridIncrement, float yGridIncrement, color gridColor)
<br /> void setTextProperties(float textSize, int decimalPlaces, String title, float titleSize, String[] channelNames, color textColor)
<br /> void addPoint(float num)
<br /> void addPoint(float[] nums)
<br /> void resetData()
<br /> void export(String tableName)
<br /> void display()

<p align="center">
  <img src="https://github.com/gubena/LiveGraph/blob/main/images/image_2023-09-08_112611164.png" />
</p>
