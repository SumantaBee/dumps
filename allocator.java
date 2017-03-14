import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.json.JSONArray;
import org.apache.tomcat.util.json.JSONException;
import org.apache.tomcat.util.json.JSONObject;

/**
 * Servlet implementation class Servlet1
 */
public class Servlet1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.json.JSONArray;
import org.apache.tomcat.util.json.JSONException;
import org.apache.tomcat.util.json.JSONObject;

/**
 * Servlet implementation class Servlet1
 */
public class Servlet1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	static final String JDBC_DRIVER="org.postgresql.Driver";
	static final String DB_URL="jdbc:postgresql://localhost/ghyo";
	
    public Servlet1() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter writer = response.getWriter();
		writer.write("Hello World");
		writer.close();
	}

	/**
	 * @param vehicles contains list of vehicle ids in JSONArray format
	 * @param order_id contains the order_id to be processed
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuilder sb = new StringBuilder();
		BufferedReader br=request.getReader();
		try {
			Class.forName(JDBC_DRIVER);
			Connection conn=DriverManager.getConnection(DB_URL,"postgres","password");
		} catch (ClassNotFoundException e1) {
			throw new IOException(e1.getMessage());
		}
		String line;
		while((line=br.readLine())!=null){
			sb.append(line);
		}
		JSONObject jsonObject=new JSONObject();
		List<Integer> listVehicles=new ArrayList<Integer>();
		Integer orderId=0;
		PrintWriter responseOut=response.getWriter();
		try {
			jsonObject=new JSONObject(sb.toString());
		} catch (JSONException e) {
			throw new IOException(e.getMessage());
		}
		try {
			JSONArray arrVehicles=jsonObject.getJSONArray("vehicles");
			orderId=jsonObject.getInt("order_id");
		} catch (JSONException e) {
			throw new IOException("Key not present");
		}
		try{
			boolean bFoundVehicle=false;
			String sql="select count(1) from orders where target_vehicle = ? and ( status = 'new' or status= 'active')";
			PreparedStatement stmt=conn.prepareStatement(sql);
			stmt.clearParameters();
			for (Integer vehicle : listVehicles) {
				System.out.println("Checking if the vehicle "+vehicle+" has any other active order");
				stmt.setInt(1, vehicle);
				ResultSet rs = stmt.executeQuery();
				boolean bAvailable=true;
				while(rs.next()){
					int count=rs.getInt(1);
					if(count==1){
						bAvailable=false;
					}
				}
				if(!bAvailable){
					System.out.println("Vehicle "+vehicle+" is unavailable");
					continue;
				}
				else{
					System.out.println("Trying vehicle "+ vehicle);
					System.out.println("Tagged target vehicle to "+ vehicle);
					String sql2="update orders set \"target_vehicle\" = ? where id = ?";
					stmt=conn.prepareStatement(sql2);
					stmt.clearParameters();
					stmt.setInt(1, vehicle);
					stmt.setInt(2, orderId);
					boolean bExecuted=stmt.execute();
					if(!bExecuted){
						System.out.println("Cannot execute query");
					} 
					System.out.println("Waiting for vehicle "+vehicle+" to accept the order");
					Thread.sleep(30000);
					String sql3="select count(*) from orders where \"vehicleId\"=? and id=?";
					System.out.println("Checking if vehicle "+ vehicle+" accepted the order");
					stmt.clearParameters();
					stmt=conn.prepareStatement(sql3);
					stmt.setInt(1, vehicle);
					stmt.setInt(2, orderId);
					rs=stmt.executeQuery();
					boolean bTagged=false;
					while(rs.next()){
						int count=rs.getInt(1);
						if(count==1){
							bTagged=true;
						}
					}
					if(!bTagged){
						System.out.println("Vehicle "+vehicle+" did not accept the order");
						continue;
					}else{
						System.out.println("Vehicle "+vehicle+" accepted the order");
						bFoundVehicle=true;
						responseOut.write("{\"code\":200,\"vehicle\":"+vehicle+"}");	
					}
				}
			}
			if(!bFoundVehicle){
				responseOut.write("{\"code\":200,\"vehicle\":null}");
			}
			responseOut.close();
			stmt.close();
			conn.close();
		}catch(SQLException e){
			response.getWriter().write("{\"code\":400}");
			throw new IOException(e.getMessage());
		}
		catch(InterruptedException e){
			response.getWriter().write("{\"code\":400}");
			throw new IOException(e.getMessage());
		}
	}

}

					System.out.println("Tagged target vehicle to "+ vehicle);
					String sql2="update orders set \"target_vehicle\" = ? where id = ?";
					stmt=conn.prepareStatement(sql2);
					stmt.clearParameters();
					stmt.setInt(1, vehicle);
					stmt.setInt(2, orderId);
					boolean bExecuted=stmt.execute();
					if(!bExecuted){
						System.out.println("Cannot execute query");
					} 
					System.out.println("Waiting for vehicle "+vehicle+" to accept the order");
					Thread.sleep(30000);
					String sql3="select count(*) from orders where \"vehicleId\"=? and id=?";
					System.out.println("Checking if vehicle "+ vehicle+" accepted the order");
					stmt.clearParameters();
					stmt=conn.prepareStatement(sql3);
					stmt.setInt(1, vehicle);
					stmt.setInt(2, orderId);
					rs=stmt.executeQuery();
					boolean bTagged=false;
					while(rs.next()){
						int count=rs.getInt(1);
						if(count==1){
							bTagged=true;
						}
					}
					if(!bTagged){
						System.out.println("Vehicle "+vehicle+" did not accept the order");
						continue;
					}else{
						System.out.println("Vehicle "+vehicle+" accepted the order");
						bFoundVehicle=true;
						responseOut.write("{\"code\":200,\"vehicle\":"+vehicle+"}");	
					}
				}
			}
			if(!bFoundVehicle){
				responseOut.write("{\"code\":200,\"vehicle\":null}");
			}
			responseOut.close();
			stmt.close();
			conn.close();
		}catch(SQLException e){
			response.getWriter().write("{\"code\":400}");
			throw new IOException(e.getMessage());
		}
		catch(InterruptedException e){
			response.getWriter().write("{\"code\":400}");
			throw new IOException(e.getMessage());
		}
	}

}
