import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Mapper.Context;



public class TweetLengthMapper extends
		Mapper<Object, Text, IntWritable, IntWritable> {

	private final IntWritable one = new IntWritable(1);
	private IntWritable bin = new IntWritable(1);

	public void map(Object key, Text value, Context context)
			throws IOException, InterruptedException {
		// Filter the tweets that are in the field format given
		// Split by ;
		String[] line = value.toString().split(";");
		// field length is 4

	if (line.length == 4) {
	    // the tweet message should not exceed 140 characters
	    // line[2] is the tweet message
        int length = line[2].length();
	if (length <= 140){

	  if (length %5 == 0){
               // bin0 since numbering starts from 0 in java
	       bin.set(length/5 -1);
	   }
	   else{
	       bin.set(length/5);
	   }

           context.write(bin, one);

	  }
        }
     }

  }
