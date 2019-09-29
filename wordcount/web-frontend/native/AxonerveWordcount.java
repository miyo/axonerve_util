public class AxonerveWordcount{
	
    private long ptr = 0;

    private native void init(String bin);
    public native void close();
    public native void reset();
	
    public native void doWordCount(byte[] words);
    public native void getResult(int[] addr, int[] value);
    public native void clear();

    public AxonerveWordcount(String bin){
        init(bin);
    }

	public void packWords(String s, int offset, byte[] words){
		if(offset + 16 >= words.length){
			return;
		}
		byte[] b = s.getBytes();
		int base = offset * 16;
		for(int i = 0; i < 16; i++){
			if(i < b.length){
				words[base + i] = b[i];
			}else{
				words[base + i] = (byte)0;
			}
		}
	}

    static {
        System.loadLibrary("axonerve_wordcount_jni");
    }

	public static void main(String... args){
		AxonerveWordcount wordcount = new AxonerveWordcount(args[0]);
		wordcount.clear();
		int num = 1024;
		byte[] words = new byte[num*16];
		for(int i = 0; i < num; i++){
			wordcount.packWords("a", i, words);
		}
		wordcount.packWords("is", 2, words);
		wordcount.packWords("is", 3, words);
		wordcount.doWordCount(words);
		int[] addrs = new int[num];
		int[] values = new int[num];
		wordcount.getResult(addrs, values);
		for(int i = 0; i < num; i++){
			System.out.printf("addr=%08x, value=%08x : ", addrs[i], values[i]);
			int a = addrs[i];
			for(int j = 0; j < 16; j++){
				System.out.printf("%02x", (int)words[16*a+j]);
			}
			System.out.println();
		}
	}

}

