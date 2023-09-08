# LiveGraph
LiveGraph is a Processing class that displays in real-time a dynamic graph that allows receiving an indefinite amount of data.
This is because when the amount of data becomes longer than the window, the graph will shift to always show the most recent values.
It also allows you to show several curves simultaneously, in which they all share the X-axis (time).

Most of its parameters are definable variables so you can customize its appearance and behavior to suit different applications.

**Constructor:**
LiveGraph (float x, float y, float windowWidth, float windowHeight, PApplet window, int numOfChannels)


**Functions:**
void setAxisProperties(float tMax, float yMin, float yMax, float timeIncrement, String yUnit)
void setGraphProperties(color backgroundColor, color lineColor, float lineThickness)
void setGridProperties(float tGridIncrement, float yGridIncrement, color gridColor)
void setTextProperties(float textSize, int decimalPlaces, String title, float titleSize, String[] channelNames, color textColor)
void addPoint(float num)
void addPoint(float[] nums)
void resetData()
void export(String tableName)
void display()
