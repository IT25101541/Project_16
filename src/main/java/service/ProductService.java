package service;

import com.yourteam.grocerymanagement.model.Product;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ProductService – manages product CRUD operations.
 * Uses Merge Sort for sorting (as per project spec).
 */
public class ProductService {

    private final FileHandler fileHandler;

    public ProductService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    // ─── CREATE ────────────────────────────────────────────────────────────────

    public Product addProduct(String name, String category, double price,
                              int stock, String expiryDate, String manufactureDate, String imageUrl) {
        Product p = new Product(IdGenerator.productId(), name, category, price,
                stock, expiryDate, manufactureDate, imageUrl);
        fileHandler.writeToFile(p.toFileString());
        return p;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        for (String line : fileHandler.readFromFile()) {
            Product p = Product.fromFileString(line);
            if (p != null) list.add(p);
        }
        return list;
    }

    public Product getProductById(String productId) {
        for (String line : fileHandler.readFromFile()) {
            Product p = Product.fromFileString(line);
            if (p != null && p.getProductId().equals(productId)) return p;
        }
        return null;
    }

    public List<Product> getProductsByCategory(String category) {
        return getAllProducts().stream()
                .filter(p -> p.getCategory().equalsIgnoreCase(category))
                .collect(Collectors.toList());
    }

    public List<Product> searchProducts(String query) {
        String q = query.toLowerCase();
        return getAllProducts().stream()
                .filter(p -> p.getName().toLowerCase().contains(q) ||
                             p.getCategory().toLowerCase().contains(q))
                .collect(Collectors.toList());
    }

    /**
     * Sort products by price using Merge Sort.
     */
    public List<Product> sortByPrice(List<Product> products) {
        return mergeSort(products, Comparator.comparingDouble(Product::getPrice));
    }

    /**
     * Sort products by category using Merge Sort.
     */
    public List<Product> sortByCategory(List<Product> products) {
        return mergeSort(products, Comparator.comparing(Product::getCategory));
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean updatePrice(String productId, double newPrice) {
        Product p = getProductById(productId);
        if (p == null) return false;
        p.setPrice(newPrice);
        return fileHandler.updateRecord(productId, p.toFileString());
    }

    public boolean updateStock(String productId, int newStock) {
        Product p = getProductById(productId);
        if (p == null) return false;
        p.setStockQuantity(newStock);
        return fileHandler.updateRecord(productId, p.toFileString());
    }

    public boolean updateCategory(String productId, String newCategory) {
        Product p = getProductById(productId);
        if (p == null) return false;
        p.setCategory(newCategory);
        return fileHandler.updateRecord(productId, p.toFileString());
    }

    public boolean updateProduct(String productId, String name, String category,
                                  double price, int stock, String expiryDate,
                                  String manufactureDate, String imageUrl) {
        Product p = getProductById(productId);
        if (p == null) return false;
        p.setName(name);
        p.setCategory(category);
        p.setPrice(price);
        p.setStockQuantity(stock);
        p.setExpiryDate(expiryDate);
        p.setManufactureDate(manufactureDate);
        p.setImageUrl(imageUrl);
        return fileHandler.updateRecord(productId, p.toFileString());
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean deleteProduct(String productId) {
        return fileHandler.deleteRecord(productId);
    }

    // ─── MERGE SORT ────────────────────────────────────────────────────────────

    private List<Product> mergeSort(List<Product> list, Comparator<Product> cmp) {
        if (list.size() <= 1) return list;
        int mid = list.size() / 2;
        List<Product> left  = mergeSort(new ArrayList<>(list.subList(0, mid)), cmp);
        List<Product> right = mergeSort(new ArrayList<>(list.subList(mid, list.size())), cmp);
        return merge(left, right, cmp);
    }

    private List<Product> merge(List<Product> left, List<Product> right, Comparator<Product> cmp) {
        List<Product> result = new ArrayList<>();
        int i = 0, j = 0;
        while (i < left.size() && j < right.size()) {
            if (cmp.compare(left.get(i), right.get(j)) <= 0) result.add(left.get(i++));
            else result.add(right.get(j++));
        }
        while (i < left.size())  result.add(left.get(i++));
        while (j < right.size()) result.add(right.get(j++));
        return result;
    }
}
