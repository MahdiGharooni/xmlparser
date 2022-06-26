
# XML Parser  

A Flutter project to parse **.xml files**. By this application you can see two samples of parsing and also you're be able to choose a directory from your device and parse subset .xml files into a **.txt file**.
  
## Getting Started  
  
### Home Page
As the first page you see the **home page** includes two buttons, **Sample Button** to see the sample inputs and the **Browse Button** to choose your directory from device and parse it.

<img src="https://github.com/MahdiGharooni/taskimages/blob/main/xml1.jpeg?raw=true"  width="250" height="500">


### Sample Page
In this page you can choose English or Italian inputs sample to see the parsed text. In fact I have saved the .xml files in our assets folder and parse them.

<img src="https://github.com/MahdiGharooni/taskimages/blob/main/xml2.jpeg?raw=true"  width="250" height="500">


### Browse Page
Finally in **Browse Page** you can choose a directory from your device and at the end, I parse all of the xml files subset of them into a .txt file. As you see in the below image, you can select the **saved icon** in the appBar and save the **result.txt** into your application data folder.

<img src="https://github.com/MahdiGharooni/taskimages/blob/main/xml3.jpeg?raw=true"  width="250" height="500">

into **/Android/0/data/com.xml_parser/files** you should see something like this:

<img src="https://github.com/MahdiGharooni/taskimages/blob/main/xml4.jpeg?raw=true"  width="280" height="500">  <img src="https://github.com/MahdiGharooni/taskimages/blob/main/xml5.jpeg?raw=true"  width="250" height="500">



## Parser
In **Parser** file I've implemented a parser file to parse a .xml file text. First of all I separate every line by **string tag**. Evety string tag includes a name and value parameters, like:

    <string name="ads_explain_1">This game is free to play.</string>
    
    
then I check some characters in them, for example replace all the extra characters with empty string or replace placeholders with correct characters. So, I define a **regex** to find the placeholder:
    
    RegExp(r'(%[0-9]*\$[a-z])')