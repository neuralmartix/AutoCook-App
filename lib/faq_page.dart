import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FAQPage extends StatefulWidget{

  @override
  State createState() => _State();


}


class _State extends State{

  Widget FAQBody(){
    return SingleChildScrollView(
      child: Column(
        children: [

          // Question 1
          Card(
            child: ExpansionTile(
              title: Text('What is carbon dioxide (CO2)?'),
              shape: Border(),
              children: [
                ListTile(
                  title: Text('Carbon dioxide (CO2) is a gas that is a natural part of Earth’s atmosphere. It is produced by various processes, including human activities like burning fossil fuels. CO2 is a greenhouse gas that traps heat in the atmosphere, which contributes to climate change and global warming.'),
                  subtitle: RichText(
                      text: TextSpan(
                      children: [
                        TextSpan(text: "Source: ", style: TextStyle(color: Colors.black),),
                        TextSpan(
                            text: 'https://climate.nasa.gov/vital-signs/carbon-dioxide/',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = (){
                              launchUrlString('https://climate.nasa.gov/vital-signs/carbon-dioxide/');
                            }
                        )
                      ]
                    ),
                  )
                )
              ],
            ),
          ),


          // Question 2
          Card(
            child: ExpansionTile(
              title: Text('How is carbon dioxide (CO2) measured?'),
              shape: Border(),
              children: [
                ListTile(
                    title: Text('Carbon dioxide is commonly measured in units of concentration, typically expressed in parts per million (ppm). This unit denotes the number of CO2 molecules in relation to a million air molecules.'),
                    subtitle: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Source: ", style: TextStyle(color: Colors.black),),
                            TextSpan(
                                text: 'https://caas.usu.edu/weather/graphical-data/co2-concentration',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  launchUrlString('https://caas.usu.edu/weather/graphical-data/co2-concentration');
                                }
                            )
                          ]
                      ),
                    )
                )
              ],
            ),
          ),

          // Question 3
          Card(
            child: ExpansionTile(
              title: Text('What are unhealthy readings of carbon dioxide (CO2)?'),
              shape: Border(),
              children: [
                ListTile(
                    title: Text('Typically, a healthy carbon dioxide level ranges from 350 - 1000 ppm. A reading below 400 ppm indicates excellent air quality, while any levels above 1000 ppm indicate poor air quality and may potentially cause headaches and other health issues.'),
                    subtitle: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Source: ", style: TextStyle(color: Colors.black),),
                            TextSpan(
                                text: 'https://www.dhs.wisconsin.gov/chemical/carbondioxide.htm',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  launchUrlString('https://www.dhs.wisconsin.gov/chemical/carbondioxide.htm');
                                }
                            )
                          ]
                      ),
                    )
                )
              ],
            ),
          ),

          // Question 4
          Card(
            child: ExpansionTile(
              title: Text('What do the different glowing colors of the necklace represent?'),
              shape: Border(),
              children: [
                ListTile(
                    title: Text(''
                      'Green = below 400 ppm\nExcellent air quality! CO2 level is very healthy.\n\n'
                      'Yellow = 400 ppm - 1000 ppm\nAcceptable air quality. CO2 level is moderate and may affect those sensitive to air pollution.\n\n'
                      'Orange = 1000 ppm - 2000 ppm\nUnhealthy air quality. CO2 level is high and may cause minor health effects such as drowsiness. Consider moving outside or opening a window if you are indoors.\n\n'
                      'Red = above 2000 ppm\nHarmful air quality. CO2 level is extremely high and risk of severe health effects is increased, including headaches and nausea. Please consider air ventilation or purification.\n'),
                    subtitle: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Source: ", style: TextStyle(color: Colors.black),),
                            TextSpan(
                                text: 'https://www.dhs.wisconsin.gov/chemical/carbondioxide.htm',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  launchUrlString('https://www.dhs.wisconsin.gov/chemical/carbondioxide.htm');
                                }
                            )
                          ]
                      ),
                    )
                )
              ],
            ),
          ),

          // Question 5
          const Card(
            child: ExpansionTile(
              title: Text('Can I use this for medical or scientific purposes?'),
              shape: Border(),
              children: [
                ListTile(
                    title: Text('CAIR is not intended for medical or scientific applications. It is designed for entertainment and educational use and as a cool fashion accessory, too!'),
                )
              ],
            ),
          ),

        ],
      )
    );
  }

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: FAQBody(),
    );
  }

}