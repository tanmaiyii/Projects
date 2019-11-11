import java.util.Arrays;
import java.util.*;
import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;


import java.io.IOException;
import java.util.Iterator;
import org.apache.hadoop.mapreduce.Reducer;

public class TwitterAthletesReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

	private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable > values, Context context)
              throws IOException, InterruptedException {

			int sum = 0;

	for(IntWritable  value: values){

                  sum += value.get();
		}

        result.set(sum);


	context.write(key, result);
    }
}
