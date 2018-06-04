//import processing.svg.*;

/*
Author: Luis Alberto
Project: Shortest path using A* algorithm
Module: GUI
Course: Artificial Intelligence
*/

import controlP5.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;
import java.util.*;



String selected = null;
String selected2 = null;
boolean cond = true;
UnfoldingMap map;//el objeto mapa
PGraphics pg;
List<Location> lst = new ArrayList<Location>();
ControlP5 cp5, cp6;
 String[] nodos;
List names = Arrays.asList("Cabo San Lucas","La Paz","Loreto","Ensenada","Tijuana",
"Mexicali","Nogales","Hermosillo","Ciudad Juarez","Chihuahua",
"Saltillo","Monterrey","Ciudad Victoria","Los Mochis","Mazatlan",
"Culiacan","Torreon","Durango","Zacatecas","San Luis Potosi",
"Tepic","Guadalajara","Aguascalientes","Guanajuato","Queretaro",
"Pachuca","Xalapa","Colima","Morelia","Toluca",
"Ciudad de Mexico","Tlaxcala","Cuernavaca","Puebla","Chilpancingo",
"Oaxaca","Villahermosa","Campeche","Merida","Chetumal",
"Tuxtla Gutierrez","Manzanillo","Nuevo Laredo","Matamoros","Tampico",
"Acapulco","Veracruz","Salina Cruz","Coatzacoalcos","Comitan",
"Cancun","Monclova","Piedras Negras");

//CIUDADES array 
Location [] location= new Location[53];

void setup() {
  float maxPanningDistance = 100;
  size(1100, 720);/*size of new map window, formerly (1100,1000)*/
  
  map = new UnfoldingMap(this,new OpenStreetMap.OpenStreetMapProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
  
  /*fixing the map location*/
  Location mexicoLocation = new Location(24f,-102.1333f);//aproximate of
  location[0]=new Location(22.894871,-109.917676);
  location[1]=new Location(24.141299,-110.311707);
  location[2]=new Location(26.011728,-111.347467);
  location[3]=new Location(31.856919,-116.604715);
  location[4]=new Location(32.511795,-117.035312);
  location[5]=new Location(32.62375,-115.453557);
  location[6]=new Location(31.301851,-110.936945);
  location[7]=new Location(29.0784761,-110.9793706);
  location[8]=new Location(31.6703988,-106.4412784);
  location[9]=new Location(28.634007,-106.073811);
  location[10]=new Location(25.428122,-100.9761904);
  location[11]=new Location(25.6488126,-100.3030789);
  location[12]=new Location(23.7358684,-99.1442161);
  location[13]=new Location(25.781529,-108.9876085);
  location[14]=new Location(23.2467867,-106.4221208);
  location[15]=new Location(24.8049172,-107.4233141);
  location[16]=new Location(25.5539641,-103.4067556);
  location[17]=new Location(24.0289606,-104.645293);
  location[18]=new Location(23.0831271,-102.5352127);
  location[19]=new Location(22.1356658,-100.9607303);
  location[20]=new Location(21.5006574,-104.883563);
  location[21]=new Location(20.673792,-103.3354131);
  location[22]=new Location(21.8890872,-102.2919885);
  location[23]=new Location(21.0251221,-101.2535212);
  location[24]=new Location(20.5910832,-100.3935927);
  location[25]=new Location(20.0893659,-98.7464502);
  location[26]=new Location(19.5354278,-96.9100715);
  location[27]=new Location(19.2465509,-103.7286585);
  location[28]=new Location(19.7039643,-101.2085714);
  location[29]=new Location(19.2944337,-99.6397071);
  location[30]=new Location(19.3200988,-99.1521845);
  location[31]=new Location(19.3067438,-98.2441899);
  location[32]=new Location(18.9316211,-99.2405376);
  location[33]=new Location(19.0412893,-98.192966);
  location[34]=new Location(17.54962,-99.4992372);
  location[35]=new Location(17.0966512,-96.7266023);
  location[36]=new Location(17.9925203,-92.9531082);
  location[37]=new Location(19.8305924,-90.5500846);
  location[38]=new Location(20.9627063,-89.6282379);
  location[39]=new Location(18.5213518,-88.3076639);
  location[40]=new Location(16.7460344,-93.132427);
  location[41]=new Location(19.0777207,-104.3377092);
  location[42]=new Location(27.451701,-99.5462553);
  location[43]=new Location(25.840444,-97.5098924);
  location[44]=new Location(22.2700063,-97.9183523);
  location[45]=new Location(16.8336281,-99.8626562);
  location[46]=new Location(19.1788058,-96.1624092);
  location[47]=new Location(16.1843,-95.2088);
  location[48]=new Location(18.1302882,-94.4619181);
  location[49]=new Location(16.23,-92.1156);
  location[50]=new Location(21.1823526,-86.808626);
  location[51]=new Location(26.9077923,-101.4239666);
  location[52]=new Location(28.6795295,-100.5447415);
  //Tequisquiapan coordinates (formerly 18f,x)
  map.zoomAndPanTo(5,mexicoLocation);//centers the map at above coordinates
  map.setZoomRange(5f,6f);//prevents from zooming out/in too much
  map.setPanningRestriction(mexicoLocation, maxPanningDistance);//sets how
  //much you can move around (in km)
  map.setTweening(true);
  
  cp5 = new ControlP5(this);
  cp5.addScrollableList("inicio")
   .setPosition(699, 0)
   .setSize(200, 100)
   .setBarHeight(20)
   .setItemHeight(20)
   .addItems(names)
   .setType(ScrollableList.DROPDOWN) 
   ;
   
   
   
  cp6 = new ControlP5(this);
  cp6.addScrollableList("destino")
   .setPosition(900, 0)
   .setSize(200, 100)
   .setBarHeight(20)
   .setItemHeight(20)
   .addItems(names)
   .setType(ScrollableList.DROPDOWN)
   ;  


}

void draw() {
map.draw();
  if(selected != null && selected2 != null && cond){ //cuando seleccionamos las ciudades
     
      println("de"+selected);
      println("a"+selected2);
     
      try{   
           PrintWriter writer = new PrintWriter("/Users/fernandasramirezm/Documents/Processing/interfazMapa/respuesta.txt");
        writer.print("#S(NODE :PATH (1 1) :PATH-LENGTH 9.99967 :TOTAL-LENGTH-ESTIMATE 9.99967)");    
           writer.close();
      println("Lanzando");
        //    delay(1000)
        
   
         String[] list = {selected, selected2};
        saveStrings("/Users/fernandasramirezm/Documents/Processing/interfazMapa/peticion.txt", list); //escribe en el file para mandar a lisp
        cond = false; 
        
//          PrintWriter writer = new PrintWriter("/Users/fernandasramirezm/Documents/Processing/interfazMapa/respuesta.txt");
//            writer.print("#S(NODE :PATH (1 1) :PATH-LENGTH 9.99967 :TOTAL-LENGTH-ESTIMATE 9.99967)");    
//            writer.close();
     //    espera(1000);  
   
      String[] cmd ={"/usr/local/bin/clisp","/Users/fernandasramirezm/Documents/Processing/interfazMapa/a-star-hash.lisp"};
      Process process = Runtime.getRuntime().exec(cmd);
      }catch( IOException ex ){
        println(ex.toString());
        println("Error corriendo batman");
      }
      
      
      if (!cond && readRoute()){
        drawRoute();
        cond = true;
      }else{
        println("Not ready");
      }
  }
 // delay(2000);
}
void espera(int dl)
{
  int time = millis();
  while(millis() - time <= dl);
}
boolean readRoute(){

   
    String aux, prueba;
        String prueba1[] = loadStrings("//Users/fernandasramirezm/Documents/Processing/interfazMapa/respuesta.txt");
        prueba= prueba1[0];
      if(prueba1.length > 0){   
        String[] parts = prueba.split("\\(",2);
        aux= parts[1];
        String [] parts2 = aux.split("\\)",2);
        aux = parts2[0];
        String [] parts1 = aux.split("\\(",2);
        aux= parts1[1];
        //System.out.println(parts1[1]);
        
        
        nodos= aux.split(" ");
        println("----------" + nodos.length);
        
    return true;
  }else{
    return false;
  }
  
}

void drawRoute(){

  
  
    for(int i=0; i<nodos.length-1;i++){ //for no loco
          //  println("holo" + nodos[i]);
            //lst.add(location[Integer.parseInt(nodos[i])-1]);
  
  //  SimpleLinesMarker linemarker = new SimpleLinesMarker(lst);
  System.out.println(Integer.parseInt(nodos[i])-1+" + "+(Integer.parseInt(nodos[i+1])-1));
    SimpleLinesMarker linemarker = new SimpleLinesMarker(location[Integer.parseInt(nodos[i])-1],location[Integer.parseInt(nodos[i+1])-1]);
     map.addMarker(linemarker);
        }
   
  
//  linemarker.setStrokeColor(10);
//  linemarker.setStrokeWeight(1);
  
  
}

void inicio(int n) {
  selected = cp5.get(ScrollableList.class, "inicio").getItem(n).get("value").toString();
  
}

void destino(int n) {
  selected2 = cp6.get(ScrollableList.class, "destino").getItem(n).get("value").toString();
 
}
