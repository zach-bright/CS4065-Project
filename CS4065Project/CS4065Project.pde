import java.io.*;

final String configPath = "config";
final String configH4 = "H4-connections.txt";
final String configSoft = "Soft-connections.txt";

BufferedReader configFile;

void setup() {
  try {
    configFile = new BufferedReader(new FileReader(configPath + File.separator + configH4));
    ConfigReader cr = new ConfigReader(configFile);
    Tree tc = cr.buildH4Tree();
  } catch (FileNotFoundException fnfe) {
    // TODO: add error for missing config
  } catch (IOException ioe) {
    // TODO: add error for failed tree build.
  }
}

void draw() {
  
}
