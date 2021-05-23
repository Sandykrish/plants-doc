import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PredictImage extends StatefulWidget {
  @override
  _PredictImageState createState() => _PredictImageState();
}

File pickedImage;
var output;
var index;

class _PredictImageState extends State<PredictImage> {
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output =
        await Tflite.runModelOnImage(path: image.path, imageStd: 224.0);
    print("predict = " + output.toString());
    // = (output);

    print("predict = " + output[0]['index'].toString());
    setState(() {
      index = output[0]['index'].toString();
    });
  }

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        print('Image Picked');
        classifyImage(pickedImage);
      } else {
        print('no image');
      }
    });
  }

  Future captureImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        print('Image Picked');
        return pickedFile;
      } else {
        print('no image');
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "model/tom-model.tflite", labels: "model/tom-label.txt");
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECF4F3),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: pickedImage == null
                      ? Image.asset(
                          "images/scan.jpg",
                          fit: BoxFit.fill,
                        )
                      : Image.file(
                          pickedImage,
                          fit: BoxFit.fill,
                        )),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      pickImage()
                          .whenComplete(() => classifyImage(pickedImage));
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Upload Image",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFF7E67)),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      captureImage();
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Capture Image",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFF7E67)),
                  ),
                )
              ],
            ),
            index == null
                ? Container()
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        //Text(output[0]['label'].toString()),

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              disease(index)[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Biological Control",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    disease(index)[1],
                                    textAlign: TextAlign.justify,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Chemical Control",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    disease(index)[2],
                                    textAlign: TextAlign.justify,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

disease(label) {
  var bio, che, dis;
  switch (label) {
    case "0":
      {
        dis = "Bacterial Spot";
        bio =
            "Bacterial Spot is very difficult to control and also expensive to treat. If the disease occurs early in the season, consider destroying the entire crop. Copper-containing bactericides provide a protective cover on foliage and fruit for both bacteria. Bacterial viruses (bacteriophages) that specifically kill the bacteria are available for the bacterial spot. Submerging seeds for one minute in 1.3% sodium hypochlorite or in hot water (50°C) for 25 minutes can reduce the incidence of both diseases. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments, if available. Copper-containing bactericides can be used as a protectant and give partial disease control. Application at first sign of disease and then at 10 to 14-day intervals when warm (spot) / cold (speck), moist conditions prevail. As the development of resistance to copper is frequent, a combination of copper-based bactericide with mancozeb is also recommended.";
      }
      break;
    case "1":
      {
        dis = "Early Blight";
        bio =
            "Application of products based on Bacillus subtilis or copper-based fungicides registered as organic can treat this disease. ";
        che =
            "Always consider an integrated approach with preventive measures and biological treatments if available. There are numerous fungicides on the market for controlling early blight. Fungicides based on or combinations of azoxystrobin, pyraclostrobin, difenoconazole, boscalid, chlorothalonil, fenamidone, maneb, mancozeb, trifloxystrobin, and ziram can be used. Rotation of different chemical compounds is recommended. Apply treatments in a timely manner, taking into account weather conditions. Check carefully the preharvest interval at which you can harvest safely after the application of these products. ";
      }
      break;
    case "2":
      {
        dis = "Late Blight";
        bio =
            "At this point, there is no biological control of known efficacy against late blight. To avoid spreading, remove and destroy plants around the infected spot immediately and do not compost infected plant material. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. Use fungicide sprays based on mandipropamid, chlorothalonil, fluazinam, mancozeb to combat late blight. Fungicides are generally needed only if the disease appears during a time of year when rain is likely or overhead irrigation is practiced. ";
      }
      break;
    case "3":
      {
        dis = "Leaf Mold";
        bio =
            "Seed treatment with hot water (25 minutes at 122 °F or 50 °C) is recommended to avoid the pathogen on seeds. The fungi Acremonium strictum, Dicyma pulvinata, Trichoderma harzianum or T. viride and Trichothecium roseum are antagonistic to M. fulva and could be used to reduce its spread. In greenhouse trials the growth of M. fulva on tomatoes was inhibited by A. strictum, Trichoderma viride strain 3 and T. roseum by 53, 66 and 84% respectively. In small arms, apple-cider, garlic or milk sprays and vinegar mix can be used to treat the mold. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. Applications should be made prior to infection when environmental conditions are optimal for the development of the disease. Recommended compounds in field use are chlorothalonil, maneb, mancozeb and copper formulations. For greenhouses, difenoconazole, mandipropamid, cymoxanil, famoxadone and cyprodinil are recommended. ";
      }
      break;
    case "4":
      {
        dis = "Septoria Leaf Spot";
        bio =
            "Copper-based fungicides, such as Bordeaux mixture, copper hydroxide, copper sulfate, or copper oxychloride sulfate might help control the pathogen. Apply at 7 to 10 day intervals throughout the late season. Follow harvest restrictions listed on the pesticide label. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. Fungicides containing maneb, mancozeb, chlorothalonil effectively control Septoria leaf spot. Apply at 7 to 10 day intervals throughout the season, mainly during flowering and fruit setting. Follow harvest restrictions listed on the pesticide label. ";
      }
      break;
    case "5":
      {
        dis = "Spider Mites";
        bio =
            "In case of minor infestation, simply wash off the mites and remove the affected leaves. Use preparations based on rapeseed, basil, soybean and neem oils to spray leaves  thoroughly and reduce populations of T. urticae.  Also try garlic tea, nettle slurry or insecticidal soap solutions to control the population. In fields, employ host-specific biological control with predatory mites (for example Phytoseiulus persimilis) or the biological pesticide Bacillus thuringiensis. A second spray treatment application 2 to 3 days after the initial treatment is necessary. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. Spider mites are very difficult to control with acaricides because most populations develop resistance to different chemicals after a few years of use. Choose chemical control agents carefully so that they do not disrupt the population of predators. Fungicides based on wettable sulfur (3 g/l), spiromesifen (1 ml/l), dicofol (5 ml/l) or abamectin can be used for example (dilution in water). A second spray treatment application 2 to 3 days after the initial treatment is necessary. ";
      }
      break;
    case "6":
      {
        dis = "Target Spot";
        bio =
            "No biological treatment seems to be available to antagonize Alternaria alternata. However, products based on copper oxychloride have been proved highly effective in controlling the disease. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. Two preventive sprayings during the blooming period or when the first symptoms appear on the fruits give good control of the disease. Product based on propiconazole, thiophanate methyl or azoxystrobine have been proved highly effective. It is important to follow the specified concentrations and to use fungicides with different mode of actions to prevent resistances. ";
      }
      break;
    case "7":
      {
        dis = "Tomato Yellow Leaf Curl Virus";
        bio =
            "There is no treatment against TYLCV. Control the whitefly population to avoid the infection with the virus. ";
        che =
            "Once infected with the virus, there are no treatments against the infection. Control the whitefly population to avoid the infection with the virus. Insecticides of the family of the pyrethroids used as soil drenches or spray during the seedling stage can reduce the population of whiteflies. However, their extensive use might promote resistance development in whitefly populations. ";
      }
      break;
    case "8":
      {
        dis = "Tomato Mosaic Virus";
        bio =
            "Dry heating seeds at 70°C for 4 days or at 82-85°C for 24 hours will help to rid them of the virus. Alternatively, seeds can be soaked for 15 min in a solution of 100 g/l of trisodium phosphate, rinsed thoroughly with water and dried. ";
        che =
            "Always consider an integrated approach with preventive measures together with biological treatments if available. There is no effective chemical treatment against Tomato Mosaic Virus. ";
      }
      break;
    default:
      {
        dis = "Healthy Plant";
        bio = "No Need";
        che = "No Need";
      }
  }
  return [dis, bio, che];
}
