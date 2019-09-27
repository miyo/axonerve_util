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
		int num = 16;
		char[] words = new char[num*16];
		for(int i = 0; i < num; i++){
			words[i*16 + 0] = 'a';
		}
		words[2*16 + 0] = 'i'; words[2*16 + 1] = 's';
		words[3*16 + 0] = 'i'; words[3*16 + 1] = 's';
		wordcount.doWordCount(words);
		int[] addrs = new int[num];
		int[] values = new int[num];
		wordcount.getResult(addrs, values);
		for(int i = 0; i < num; i++){
			System.out.printf("values=%08x, addr=%08x\n", addrs[i], values[i]);
		}
	}

}

