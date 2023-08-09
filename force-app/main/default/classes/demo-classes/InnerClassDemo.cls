public class InnerClassDemo {
    private List<InnerClass> numbers;

    public InnerClassDemo() {
        this.numbers = new List<InnerClass>();
    }

    public void addNumber(Integer x) {
        InnerClass innerClass = new InnerClass(x);
        this.numbers.add(innerClass);
    }

    public override String toString() {
        String result = '';
        for (InnerClass num : numbers) {
            result += String.valueOf(num) + ' ';
        }
        return result;
    }

    private class InnerClass {
        private Integer x;
        public InnerClass(Integer x) {
            this.x = x;
        }

        public override String toString() {
            return String.valueOf(x);
        }
    }
}
