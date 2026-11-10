public class SimpleStack<T> {
    private static class Node<T> {
        T value;
        Node<T> next;
        Node(T value, Node<T> next) {
            this.value = value;
            this.next = next;
        }
    }

    private Node<T> top;
    private int size;

    public void push(T value) {
        top = new Node<>(value, top);
        size++;
    }

    public T pop() {
        if (top == null) throw new IllegalStateException("Stack is empty.");
        T value = top.value;
        top = top.next;
        size--;
        return value;
    }

    public T peek() {
        if (top == null) throw new IllegalStateException("Stack is empty.");
        return top.value;
    }

    public boolean isEmpty() { return size == 0; }
    public int size() { return size; }
}
