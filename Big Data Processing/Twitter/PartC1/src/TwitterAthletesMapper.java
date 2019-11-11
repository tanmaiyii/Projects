import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.Calendar;
import java.util.Hashtable;

import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.io.IntWritable;
import java.util.*;
import java.lang.*;
import java.util.ArrayList;

public class TwitterAthletesMapper extends Mapper<Object, Text, Text, IntWritable> {

	private Hashtable <String, String> athlete;

	private Text name = new Text();
	private IntWritable one = new IntWritable(1);

	public void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		String[] tweetDetails = value.toString().split(";");
                if (tweetDetails.length == 4) {
		// here we match the two tables in the joins
    		String tweet = tweetDetails[2];

                if (tweet!=null) {

                    Set<String> athleteNames = athlete.keySet();
                    
                    for(String athleteName : athleteNames) {
                     if(tweet.contains(athleteName)) {
               // the key of the hashtable (name)-fields[1] is set as the key for the mapper
			name.set(athleteName);

		    context.write(name, one);

                       }

                   }
              }

          }
     }
  


	@Override
	protected void setup(Context context) throws IOException, InterruptedException {

		athlete = new Hashtable <String, String>();

		// We know there is only one cache file, so we only retrieve that URI
		URI fileUri = context.getCacheFiles()[0];

		FileSystem fs = FileSystem.get(context.getConfiguration());
		FSDataInputStream in = fs.open(new Path(fileUri));

		BufferedReader br = new BufferedReader(new InputStreamReader(in));

		String line = null;
		try {
			// we discard the header row
			br.readLine();

			while ((line = br.readLine()) != null) {
				//context.getCounter(CustomCounters.NUM_ATHLETES).increment(1);

				String[] fields = line.split(",");
				// Fields[1] is athlete name and fields[7] is sports
				if (fields.length == 11)
					athlete.put(fields[1], fields[7]);
			}
			br.close();
		} catch (IOException e1) {
		}

		super.setup(context);
	}

}
