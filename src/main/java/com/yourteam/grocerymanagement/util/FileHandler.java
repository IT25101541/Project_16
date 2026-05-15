package com.yourteam.grocerymanagement.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FileHandler – Generic utility for file-based data persistence.
 * Demonstrates Abstraction: hides file I/O details from service classes.
 */
public class FileHandler {

    private final String filePath;

    public FileHandler(String filePath) {
        this.filePath = filePath;
        ensureFileExists();
    }

    private void ensureFileExists() {
        try {
            File f = new File(filePath);
            f.getParentFile().mkdirs();
            if (!f.exists()) f.createNewFile();
        } catch (IOException e) {
            System.err.println("FileHandler: could not create file: " + filePath + " - " + e.getMessage());
        }
    }

    /**
     * Append a line to the file.
     */
    public void writeToFile(String data) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
            bw.write(data);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("FileHandler writeToFile error: " + e.getMessage());
        }
    }

    /**
     * Read all non-empty lines.
     */
    public List<String> readFromFile() {
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) lines.add(line.trim());
            }
        } catch (IOException e) {
            System.err.println("FileHandler readFromFile error: " + e.getMessage());
        }
        return lines;
    }

    /**
     * Update a record: replaces a line that starts with the given key.
     * @param key      Prefix to match (e.g. "USR001")
     * @param newData  Replacement line
     */
    public boolean updateRecord(String key, String newData) {
        List<String> lines = readFromFile();
        boolean updated = false;
        List<String> updated_lines = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(key + "|") || line.equals(key)) {
                updated_lines.add(newData);
                updated = true;
            } else {
                updated_lines.add(line);
            }
        }
        if (updated) writeAll(updated_lines);
        return updated;
    }

    /**
     * Delete a record: removes any line starting with the given key.
     */
    public boolean deleteRecord(String key) {
        List<String> lines = readFromFile();
        int before = lines.size();
        lines.removeIf(l -> l.startsWith(key + "|") || l.equals(key));
        if (lines.size() < before) {
            writeAll(lines);
            return true;
        }
        return false;
    }

    /**
     * Overwrite entire file with a list of lines.
     */
    public void writeAll(List<String> lines) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("FileHandler writeAll error: " + e.getMessage());
        }
    }

    /**
     * Check if any line starts with the key.
     */
    public boolean recordExists(String key) {
        for (String line : readFromFile()) {
            if (line.startsWith(key + "|")) return true;
        }
        return false;
    }

    public String getFilePath() { return filePath; }
}
