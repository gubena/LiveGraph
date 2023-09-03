// =============================================
// CLASS LIVE GRAPH (Chart Object for the Demo GUI)
// by Guillem Benavent (Updated: 28/8/2023)
// For Research Project at Taradell School
// =============================================
// A LiveGraph shows a dinamic chart ploted from a stream of data.
// It allows an undefined length of data through automatic scroll.
// It also allows to plot multiple channels if they share the same Y axis range.
// =============================================

class LiveGraph
{
  PApplet window;
  
  float PIX_MARGIN = 60;
  FloatList[] dataPoints;

  // Position and Sizes of the LiveGraph
  float xPos;
  float yPos;
  float windowWidth;
  float windowHeight;
  float graphWidth;
  float graphHeight;
  
  // Axis limit values and parameters 
  float tMax;
  float yMax;
  float yMin;
  float timeIncrement;
  int maxPoints;
  String yUnit;
  
  // Graph line properties
  color backgroundColor = color(255);
  color lineColor;
  float lineThickness;
  
  float margin = 15;  //??
  
  // Grid parameters
  float tGridIncrement;
  float yGridIncrement;
  color gridColor;
  
  // Text Properties
  float textSize;
  int decimalPlaces;
  String title;
  float titleSize;
  String channelNames[];
  color textColor;
    
  // Other
  float zeroYPos;
  int numOfExport = 0;

  // Constructors ==============================================
  
  LiveGraph(float xPos, float yPos, float windowWidth, float windowHeight, PApplet window)
  {
    this(xPos, yPos, windowWidth, windowHeight, window, 1);
  }
  
  LiveGraph(float xPos, float yPos, float windowWidth, float windowHeight, PApplet window, int numOfChannels)
  {
    this.window = window;
    
    this.xPos = xPos;
    this.yPos = yPos;
    this.windowWidth = windowWidth;
    this.windowHeight = windowHeight;
    
    this.graphHeight = this.windowHeight-2*PIX_MARGIN;
    this.graphWidth = this.windowWidth-4*PIX_MARGIN;
    // If is multichannel, let's keep space for the legend:
    //if (numOfChannels>=1) { this.graphWidth = this.graphWidth -2*PIX_MARGIN; }  
    
    this.channelNames = new String[numOfChannels];
    for (int i=0; i<numOfChannels; i++)
    {
      this.channelNames[i] = "Channel #"+i;
    }
    
    dataPoints = new FloatList[numOfChannels];
    resetData();
  }
  
  // Properties Setters: Axis, Graph, Grid, Text =========================================== 
  
  void setAxisProperties(float tMax, float yMin, float yMax, float timeIncrement)
  {
    setAxisProperties(tMax, yMin, yMax, timeIncrement, "");
  }  
  
  void setAxisProperties(float tMax, float yMin, float yMax, float timeIncrement, String yUnit)
  {
    this.tMax = tMax;
    this.yMax = yMax;
    this.yMin = yMin;
    this.timeIncrement = timeIncrement;
    this.yUnit = yUnit;
    
    this.maxPoints = int(nf(tMax/timeIncrement , 0, 0));
    this.zeroYPos = map(0, yMax, yMin, margin, windowHeight);
  }
  
  void setGraphProperties(color backgroundColor, color lineColor)
  {
    setGraphProperties(backgroundColor, lineColor, 1);
  }
  
  void setGraphProperties(color backgroundColor, color lineColor, float lineThickness)
  {
    this.backgroundColor = backgroundColor;
    this.lineColor = lineColor;
    this.lineThickness = lineThickness;
  }
  
  void setGridProperties(float tGridIncrement, float yGridIncrement, color gridColor)
  {
    this.tGridIncrement = tGridIncrement;
    this.yGridIncrement = yGridIncrement;
    this.gridColor = gridColor;
  }
  
  void setTextProperties(float textSize, int decimalPlaces)
  {
    setTextProperties(textSize, decimalPlaces, "", 1, null, color(0));
  }  
  
  void setTextProperties(float textSize, int decimalPlaces, String title, float titleSize)
  {
    setTextProperties(textSize, decimalPlaces, title, titleSize, null, color(0));
  }
  
  void setTextProperties(float textSize, int decimalPlaces, String title, float titleSize, String[] channelNames, color textColor)
  {
    this.textSize = textSize;
    this.decimalPlaces = decimalPlaces;
    this.title = title;
    this.titleSize = titleSize; 
    this.textColor = textColor;
    
    if (channelNames!=null) 
    {
      this.channelNames = channelNames;
    }
  }

  
  // Data functions ========================================================
  
  void addPoint(float num)
  {
    addPoint(new float[]{num});
  }
  
  void addPoint(float[] nums)
  {
    for (int i = 0; i < dataPoints.length; i++)
    {
      dataPoints[i].append(nums[i]);
    }
  }
  

  void resetData()
  {
    int numOfChannels = dataPoints.length;
    for (int i = 0; i < numOfChannels; i++)
    {
      dataPoints[i] = new FloatList();
    }
  }
  
  void export(String tableName)
  {
    PrintWriter output;
    output = createWriter(tableName+".csv");
    String header = new String("time (s)");
    for (int i = 0; i < dataPoints.length; i++)
    {
      header = header + ", " + channelNames[i];
    }
    output.println(header);
   
    for (int i = 0; i < dataPoints[0].size(); i++)
    {
      String newLine = new String(str(timeIncrement*i));
      for (int j = 0; j < dataPoints.length; j++)
      {
        newLine = newLine + ", " + str(dataPoints[j].get(i));
      }
      output.println(newLine);
    }
    output.flush();
    output.close();
  }
  
  // Display functions =====================================================
  
  void display()
  {
    PVector pix, endPix;
    //PVector val, endVal;
    String text;
    
    //graph shift
    int iShift = 0;
    float tShift = 0.0;
    if(dataPoints[0].size() >= maxPoints)
    {
      iShift = dataPoints[0].size() - maxPoints;
      tShift = iShift * timeIncrement;
    }
      
    // Window
    window.fill(backgroundColor);
    window.noStroke();
    window.rectMode(CORNER);
    window.rect(xPos, yPos, windowWidth, windowHeight);
    
    // Graph area
    pix = unitsToWindow(0, yMax, 0);
    window.fill(gridColor);
    window.noStroke();
    window.rectMode(CORNER);
    window.rect(pix.x, pix.y, graphWidth, graphHeight);
    window.fill(backgroundColor);
    window.rect(pix.x+1, pix.y+1, graphWidth-1, graphHeight-1);
    
    // Y axis
    window.strokeWeight(2);
    window.stroke(gridColor);
    //0 Line
    if (yMax>0 && yMin<0)
    {
      pix = unitsToWindow(0, 0, 0);
      endPix = unitsToWindow(tMax, 0, 0);
      window.line(pix.x, pix.y, endPix.x, endPix.y);
    }
        
    // Y grid
    window.strokeWeight(1);
    window.stroke(gridColor);
    float yRange = yMax - yMin;
    float numberOfDivisions = floor(yRange/yGridIncrement);
    float zeroOffset = ((yMin / yGridIncrement)-floor(yMin / yGridIncrement)) * yGridIncrement;
    
    for (int i=0; i<=numberOfDivisions+1; i++)
    {
      float y = yMin + i*yGridIncrement - zeroOffset;
      float yBottomLineValue;
      if ((y>=yMin) && (y<=yMax)) 
      {
        pix = unitsToWindow(0, y);
        endPix = unitsToWindow(tMax, y);
        window.fill(gridColor);
        window.line(pix.x, pix.y, endPix.x, endPix.y);
        
        
        pix = unitsToWindow(0, y);
        endPix = unitsToWindow(0, 0);
        yBottomLineValue = floor((endPix.y-pix.y)/yGridIncrement);
        window.textAlign(CENTER);
        window.textSize(textSize);
        window.fill(textColor);
        text = nf(y, 0, decimalPlaces);     
        window.text(text, xPos+PIX_MARGIN - textWidth(text)*(textSize/100) - 5, pix.y+textSize/4);
      }
    }                                                                //2 thirds because it looks good
    window.text(yUnit, xPos+(PIX_MARGIN)- textWidth(yUnit)*(textSize/100) -3, yPos+(2*PIX_MARGIN/3));
    
    
    // X grid
    numberOfDivisions = floor(tMax/tGridIncrement);
    float dShift = floor(tShift/tGridIncrement);
    float zeroTimeOffset = ((tShift / tGridIncrement)-dShift) * tGridIncrement;

    for (int i=0; i<=numberOfDivisions+1; i++)
    {
      float t = i*tGridIncrement - zeroTimeOffset;
      if (t<=tMax && t>=0) 
      {
        pix = unitsToWindow(t, yMin);
        endPix = unitsToWindow(t, yMax);
        window.fill(gridColor);
        window.line(pix.x, pix.y, endPix.x, endPix.y);
        
        window.textAlign(CENTER);
        window.textSize(textSize);
        window.fill(textColor);
        text = nf((i+dShift) * tGridIncrement, 0, decimalPlaces);
        window.text(text, pix.x, yPos + PIX_MARGIN + graphHeight + textSize);
      }
    }
    window.textSize(textSize);
    window.text("s", xPos+PIX_MARGIN + graphWidth + textSize/2 + textSize, yPos + PIX_MARGIN + graphHeight + textSize);
    
    // Data lines
    window.strokeWeight(lineThickness);
    for(int i = 0; i < dataPoints.length; i++)
    {
      window.stroke(lerpColor(lineColor, color(255), float(i)/float(dataPoints.length))); 
      for(int j = iShift+1; j < dataPoints[i].size(); j++)
      { 
        pix = unitsToWindow(j*timeIncrement, dataPoints[i].get(j), tShift);
        endPix = unitsToWindow((j-1)*timeIncrement, dataPoints[i].get(j-1), tShift);
        float yPixelValueMax = yPos+PIX_MARGIN;
        if(pix.y<yPixelValueMax) {pix.y = yPixelValueMax;}
        if(endPix.y<yPixelValueMax) {endPix.y = yPixelValueMax;}
        float yPixelValueMin = yPos+PIX_MARGIN+graphHeight;
        if(pix.y>yPixelValueMin) {pix.y = yPixelValueMin;}
        if(endPix.y>yPixelValueMin) {endPix.y = yPixelValueMin;}
        window.line(pix.x, pix.y, endPix.x, endPix.y);
      }
    }
    
    // Title
    window.textSize(titleSize);
    window.textAlign(CENTER);
    window.fill(textColor);
    window.text(title, xPos + windowWidth/2, yPos + PIX_MARGIN/2 + titleSize/3);
    
    // Legend
    if (channelNames!=null && channelNames.length>0)
    {
      float incY = graphHeight / (1+channelNames.length);
      float absX = xPos + PIX_MARGIN + graphWidth + PIX_MARGIN/2;
      float absY = yPos + PIX_MARGIN + graphHeight - incY;
      float squareSize = PIX_MARGIN/3;
      if (squareSize>=incY) { squareSize=incY-1; }

      window.noStroke();
      window.rectMode(CENTER);      

      for(int i = 0; i < channelNames.length; i++)
      {
        window.fill(lerpColor(lineColor, color(255), float(i)/float(channelNames.length)));
        window.rect(absX, absY-(incY*i), squareSize, squareSize);
        
        window.textSize(textSize);
        window.text(channelNames[i], absX + squareSize + 2*textSize, absY-(incY*(0.25+i)) + textSize);
      }
    }
  }
  
  
  PVector unitsToWindow(float t, float y)
  {
    return unitsToWindow(t, y, 0);
  }
  PVector unitsToWindow(float t, float y, float tShift)
  {
    float pixX = xPos + (PIX_MARGIN) + map(t-tShift, 0, tMax, 0, graphWidth);
    float pixY = yPos + windowHeight - (PIX_MARGIN) - map(y, yMin, yMax, 0, graphHeight);
    return(new PVector(pixX, pixY));
  }
  
 
}
