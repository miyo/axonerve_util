
import java.io.File;
import java.io.IOException;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Comparator;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class WordcountJava {

	private Hashtable<String, Integer> tbl;
	private ArrayList<String> uniqWords;
	private String[] words;

	public WordcountJava(){
	}
	
	public void load(String srcFileName){
		tbl = new Hashtable<>();
		uniqWords = new ArrayList<>();
        String str = "";
		try{
			str = Files.readString(Path.of(srcFileName), Charset.forName("UTF-8"));
		}catch(IOException e){
			e.printStackTrace();
			System.exit(0);
		}
		words = str.split("\\s+");
	}
	
	public void count(String srcFileName){
		for(String s: words){
			Integer v = tbl.get(s);
			if(v == null){
				tbl.put(s, 1);
				uniqWords.add(s);
			}else{
				tbl.put(s, v.intValue() + 1);
			}
		}
	}

	public void sort(){
		uniqWords.sort(new CountComparator(tbl));
	}
	
	public void dump(){
		for(String w: uniqWords){
			System.out.println(w + " => " + tbl.get(w));
		}
	}

	class CountComparator implements Comparator<String>{
		private Hashtable<String, Integer> tbl;
		
		CountComparator(Hashtable<String, Integer> tbl){
			this.tbl = tbl;
		}
		
		public int compare(String l, String r) {
			Integer lv = tbl.get(l);
			Integer rv = tbl.get(r);
			if(lv == null) lv = Integer.MIN_VALUE;
			if(rv == null) rv = Integer.MIN_VALUE;
			if(lv < rv){
				return -1;
			}else if(lv > rv){
				return 1;
			}else{
				return 0;
			}
		}
	}

	public int getNumOfWords(){
		return words.length;
	}
	public int getNumOfUniqWords(){
		return uniqWords.size();
	}

	public static void main(String... args){
		WordcountJava obj = new WordcountJava();
		if(args.length == 0 || ((new File(args[0])).exists() == false)){
			System.out.println("usage: java WordcountJava textFileName");
			System.exit(0);
		}
		long t0 = System.currentTimeMillis();
		obj.load(args[0]);
		long t1 = System.currentTimeMillis();
		obj.count(args[0]);
		long t2 = System.currentTimeMillis();
		obj.sort();
		//obj.dump();
		System.out.println("----");
		System.out.println("elapsed tiem for WordcountJava.load(): " + (t1-t0) + " ms.");
		System.out.println("elapsed tiem for WordcountJava.count(): " + (t2-t1) + " ms.");
		System.out.println("#. of unique words: " + obj.getNumOfUniqWords());
		System.out.println("#. of words: " + obj.getNumOfWords());
		long bytes = (new File(args[0])).length();
		System.out.println("File size: " + bytes + " Bytes");
		System.out.printf("Throughput: %.3f Mwords/s, %.3f MB/s",
						  (((double)obj.getNumOfWords())/((double)(t2-t0)))/1000.0,
						  (((double)bytes)/((double)(t2-t0)))/1000.0);
		System.out.println();
	}
	
}
