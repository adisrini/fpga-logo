package mif;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class ColorMapping {
    
    private static Map<String, Integer> mapping;
    
    static class Sprite {
        
        int[] grid;
        
        Sprite(int[] grid) {
            this.grid = grid;
        }
        
        int[][] grid() {
            int[][] grid = new int[15][15];
            for(int i = 0; i < 15; i++) {
                for(int j = 0; j < 15; j++) {
                    grid[j][i] = this.grid[(j*15) + i]; 
                }
            }
            return grid;
        }
        
    }
    
    static enum Direction {
        NORTH("turtle_north.txt"),
        EAST("turtle_east.txt"),
        SOUTH("turtle_south.txt"),
        WEST("turtle_west.txt");
        
        Sprite sprite;
        
        Direction(String file) {
            sprite = sprite(file);
        }
    }
    
    
    static {
        try(BufferedReader br = new BufferedReader(new InputStreamReader(ColorMapping.class.getResourceAsStream("turtle_north.txt"), "UTF-8"))) {
            StringBuilder sb = new StringBuilder();
            String ln = br.readLine();
            while (ln != null) {
                sb.append(ln);
                sb.append(System.lineSeparator());
                ln = br.readLine();
            }
            String file = sb.toString();
            int index = 0;
            mapping = new HashMap<String, Integer>();
            String[] lines = file.split("\n");
            for(String line : lines) {
                String[] components = line.split(":");
                String color = components[1].trim();
                if(!mapping.containsKey(color)) {
                    mapping.put(color, index);
                    index++;
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        try{
            PrintWriter writer = new PrintWriter("img-bars.mif", "UTF-8");
            for(String line : datafile(0, 0, Direction.NORTH)) {
                writer.print(line);
            }
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private static String[] datafile(int r, int c, Direction direction) {
        String[] lines = new String[640*480];
        Sprite sprite = direction.sprite;
        for(int i = 0; i < lines.length; i++) {
            StringBuilder builder = new StringBuilder();
            builder.append(Integer.toHexString(i).toUpperCase());
            builder.append(":");
            String color = "0";
            builder.append(color);
            builder.append(";\n");
            lines[i] = builder.toString();
        }
        // r = 2
        // c = 1
        // row = 30, 31, 32, ...
        // col = 15, 16, 17, ...
        for(int row = r*15; row < r*15 + 15; row++) {
            for(int col = c*15; col < c*15 + 15; col++) {
                StringBuilder builder = new StringBuilder();
                int index = 640*row + col + 80;
                builder.append(Integer.toHexString(index).toUpperCase());
                builder.append(":");
                String color = Integer.toHexString(sprite.grid[(row - r*15)*15 + (col - c*15)]);
                builder.append(color);
                builder.append(";\n");
                lines[index] = builder.toString();
            }
        }
        return lines;
    }
    
    public static void main(String[] args) {
        
    }
    
    private static Sprite sprite(String fl)  {
        try(BufferedReader br = new BufferedReader(new InputStreamReader(ColorMapping.class.getResourceAsStream(fl), "UTF-8"))) {
            StringBuilder sb = new StringBuilder();
            String ln = br.readLine();

            while (ln != null) {
                sb.append(ln);
                sb.append(System.lineSeparator());
                ln = br.readLine();
            }
            String file = sb.toString();
            int[] grid = new int[225];
            int address = 0;
            String[] lines = file.split("\n");
            for(String line : lines) {
                String[] components = line.split(":");
                String color = components[1].trim();
                grid[address] = mapping.get(color);
                address++;
            }
            return new Sprite(grid);
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
}
