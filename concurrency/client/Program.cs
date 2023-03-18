using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Microsoft.Data.SqlClient;

namespace MyProject;
class Program
{
    static async Task Main(string[] args)
    {
        int n = 0;
        int r = 1000;

        if (int.TryParse(args[0], out n) == false) {
            Console.WriteLine("Please type the number of demo you want to run");
            return;
        }

        if ((args.Length == 2) && (int.TryParse(args[1], out r) == false))
        {
            Console.WriteLine("Row number must be an integer");
            return;
        }        

        var demo = new Demo();
        await demo.Run(n, r);        
    }
}

class Demo {

    const string ConnectionString = "Server=localhost;Database=sqlbits_concurrency;Application Name=Demo;User ID=DemoUser;Password=45m98asW_232!!s4SDF;TrustServerCertificate=True;";

    public async Task Run(int n, int r) {
        int taskCount = 2;

        Console.WriteLine("Adding tasks...");

        var tasks = new List<Task>();    
        var mi = this.GetType().GetMethod($"RunDemo_{n}", BindingFlags.NonPublic | BindingFlags.Instance);

        Enumerable.Range(1, taskCount).ToList().ForEach(
            i => tasks.Add( 
                (Task)(mi.Invoke(this, new object[] { new object[] { i, r }}))
            )      
        );
        
        await Task.WhenAll(tasks);

        Console.WriteLine("Done");
    }

    /*
        Demo 1:
        Just connect to the database and then wait
    */
    private async Task RunDemo_1(params object[] args) {
        int taskId = (int)args[0];
        using (var conn = new SqlConnection(ConnectionString)) {            
            await conn.OpenAsync();            
            
            Console.WriteLine(String.Format("[{0}]: Connected.", taskId));

            await Task.Delay(100000); 
        }
    }

    /*
        Demo 2:
        Using default transaction level (read committed)
        Start from rowCount=1000 and then change it to 1000000 
        to exahust the TCP transmission buffer
    */
    private async Task RunDemo_2(params object[] args) {
        int taskId = (int)args[0];
        int rowCount = (int)args[1];

        Console.WriteLine(String.Format("[{0}]: Reading {1} rows.", taskId, rowCount));

        var r = new Random();
        await Task.Delay(r.Next(500, 1500));

        using (var conn = new SqlConnection(ConnectionString)) {            
            await conn.OpenAsync();            
            
            var cmd = new SqlCommand($"SELECT * FROM dbo.timesheet_big WHERE id BETWEEN 1 AND {rowCount} ORDER BY id", conn);            

            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine(String.Format("[{0}]: Id:{1}", taskId, reader[0]));
                await Task.Delay(r.Next(500, 1500));
            }
        }
    }

    /*
        Demo 3:
        Move to a higher transaction level (repeatable read)
        Start from rowCount=1000 and then change it to 1000000 
        to exahust the TCP transmission buffer
    */
    private async Task RunDemo_3(params object[] args) {
        int taskId = (int)args[0];
        int rowCount = (int)args[1];

        Console.WriteLine(String.Format("[{0}]: Reading {1} rows.", taskId, rowCount));

        var r = new Random();
        await Task.Delay(r.Next(500, 1500));

        using (var conn = new SqlConnection(ConnectionString)) {            
            await conn.OpenAsync();            
            
            var tran = conn.BeginTransaction(IsolationLevel.RepeatableRead);

            var cmd = new SqlCommand($"SELECT * FROM dbo.timesheet_big WHERE id BETWEEN 1 AND {rowCount} ORDER BY id", conn, tran);            

            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine(String.Format("[{0}]: Id:{1}", taskId, reader[0]));
                await Task.Delay(r.Next(500, 1500));
            }

            tran.Commit();            
        }
    }  
}
