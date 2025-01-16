/*
 * Bike Map showing all Cycle Hire stations and their available bikes.
 *
 * Example shows how to load and display CSV data. Shows bike stations directly (i.e. without markers)
 *
 * Created for Unfolding workshop at Royal College of Art.
 * (c) 2014 Till Nagel, tillnagel.com
 */ 
 
 //https://www.kaggle.com/datasets/edomingo/bicing-stations-dataset-bcn-bike-sharing
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

//String bikeAPIUrl = "http://api.bike-stats.co.uk/service/rest/bikestats?format=csv";
String bikeFile = "opendatabcn-transports-transports-addicionals-parades-taxi-csv-csv.csv"; // in case URL goes down
String bikeDataFile = bikeFile;

UnfoldingMap map;

ArrayList<BikeStation> bikeStations = new ArrayList();
int maxBikesAvailable = 0;

void setup() {
  size(800, 600, P2D);
  smooth();

  // Create interactive map centered around London
  map = new UnfoldingMap(this);
  map.zoomAndPanTo(13, new Location(41.38879, 2.15899));
  MapUtils.createDefaultEventDispatcher(this, map);
  
  map.setTweening(true);
  
  // Load CSV data
  Table bikeDataCSV = loadTable(bikeDataFile, "header, csv");
  for (TableRow bikeStationRow : bikeDataCSV.rows()) {
    // Create new empty object to store data
    BikeStation bikeStation = new BikeStation();

    // Read data from CSV
    bikeStation.id = bikeStationRow.getInt("register_id");
    bikeStation.name = bikeStationRow.getString("name");
    bikeStation.bikesAvailable = bikeStationRow.getInt("register_id");
    float lat = bikeStationRow.getFloat("geo_epgs_4326_lat");
    float lng = bikeStationRow.getFloat("geo_epgs_4326_lon");
    bikeStation.location = new Location(lat, lng);

    // Add to list of all bike stations
    bikeStations.add(bikeStation);

    // Debug Info
    //println("Added " + bikeStation.name + " with " + bikeStation.bikesAvailable + " bikes.";

    // Statistics (well, sort of)
    maxBikesAvailable = max(maxBikesAvailable, bikeStation.bikesAvailable);
  }

  println("Loaded " + bikeStations.size() + " bikeStations. Max bikes: " + maxBikesAvailable);
}

void draw() {
  // Draw map and darken it a bit
  map.draw();
  fill(0, 200);
  rect(0, 0, width, height);

  noStroke();

  // Iterate over all bike stations
  for (BikeStation bikeStation : bikeStations) {
    // Convert geo locations to screen positions
    ScreenPosition pos = map.getScreenPosition(bikeStation.location);
    // Map number of free bikes to radius of circle
    float s = map(bikeStation.bikesAvailable, 0, maxBikesAvailable, 1, 50);
    // Draw circle according to available bikes
    fill(255, 50);
    ellipse(pos.x, pos.y, 10, 10);

    if (bikeStation.showLabel) {
      fill(200);
      text(bikeStation.name, pos.x - textWidth(bikeStation.name)/2, pos.y);
    }
  }
}

void mouseClicked() {
  // Simple way of displaying bike station names. Use markers for single station selection.
  for (BikeStation bikeStation : bikeStations) {
    bikeStation.showLabel = false;
    ScreenPosition pos = map.getScreenPosition(bikeStation.location);
    if (dist(pos.x, pos.y, mouseX, mouseY) < 10) {
      bikeStation.showLabel = true;
    }
  }
}
