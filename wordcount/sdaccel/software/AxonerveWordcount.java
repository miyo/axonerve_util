public class AxonerveWordcount{
	
    private long ptr = 0;

    private native void init(String bin);
    public native void close();
    public native void reset();
	
    public native void doWordCount(char[] words);
    public native void getResult(int[] addr, int[] value);
    public native void clear();

    public AxonerveWordcount(String bin){
        init(bin);
    }

    static {
        System.loadLibrary("axonerve_wordcount_jni");
    }

	public static void main(String... args){
		AxonerveWordcount wordcount = new AxonerveWordcount(args[0]);
		wordcount.clear();
	}

}

