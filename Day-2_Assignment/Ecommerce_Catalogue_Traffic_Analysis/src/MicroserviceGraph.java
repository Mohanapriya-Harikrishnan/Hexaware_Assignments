import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;

class MicroserviceGraph {
    private final Map<String, List<String>> graph = new LinkedHashMap<>();

    void addService(String service) {
        graph.putIfAbsent(service, new ArrayList<>());
    }

    // An edge A -> B means A must be deployed before B.
    void addDependency(String before, String after) {
        addService(before);
        addService(after);
        graph.get(before).add(after);
    }

    List<String> deploymentOrderBFS() {
        Map<String, Integer> indegree = new LinkedHashMap<>();
        for (String service : graph.keySet()) indegree.put(service, 0);
        for (String service : graph.keySet()) {
            for (String next : graph.get(service)) {
                indegree.put(next, indegree.get(next) + 1);
            }
        }

        Queue<String> queue = new LinkedList<>();
        for (String service : graph.keySet()) {
            if (indegree.get(service) == 0) queue.add(service);
        }

        List<String> order = new ArrayList<>();
        while (!queue.isEmpty()) {
            String current = queue.remove();
            order.add(current);
            for (String next : graph.get(current)) {
                indegree.put(next, indegree.get(next) - 1);
                if (indegree.get(next) == 0) queue.add(next);
            }
        }
        return order.size() == graph.size() ? order : new ArrayList<>();
    }

    boolean hasCycleDFS() {
        Map<String, Integer> state = new HashMap<>();
        for (String service : graph.keySet()) state.put(service, 0);

        for (String service : graph.keySet()) {
            if (state.get(service) == 0 && visit(service, state)) return true;
        }
        return false;
    }

    private boolean visit(String service, Map<String, Integer> state) {
        state.put(service, 1); // 1 means the service is being visited
        for (String next : graph.get(service)) {
            if (state.get(next) == 1) return true;
            if (state.get(next) == 0 && visit(next, state)) return true;
        }
        state.put(service, 2); // 2 means the service is fully visited
        return false;
    }

    static void run() {
        MicroserviceGraph services = new MicroserviceGraph();
        services.addDependency("Inventory", "Pricing");
        services.addDependency("Pricing", "Cart");
        services.addDependency("Cart", "API Gateway");
        services.addDependency("Payment", "Cart");
        services.addDependency("Notification", "Payment");

        System.out.println("Valid deployment order (BFS): " + services.deploymentOrderBFS());
        System.out.println("Circular dependency before change: " + services.hasCycleDFS());

        // This extra link creates a cycle in the dependency graph.
        services.addDependency("API Gateway", "Inventory");
        System.out.println("After adding API Gateway -> Inventory, circular dependency: " + services.hasCycleDFS());
        System.out.println("Deployment order after cycle: " +
            (services.deploymentOrderBFS().isEmpty() ? "Not possible (cycle exists)" : services.deploymentOrderBFS()));
    }
}
