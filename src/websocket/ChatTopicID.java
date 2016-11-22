package websocket;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import dao.UserDAO;
import rule.VerifySource;
import util.MD5;
import vo.User;

@ServerEndpoint("/chattopic/{room}")
public class ChatTopicID {
    private static int onlineCount = 0;  //未完成
    private static int idCount = 0;  //未完成

    private static ConcurrentSkipListMap<Integer,CopyOnWriteArraySet<ChatTopicID>> webSocketListMap = new ConcurrentSkipListMap<>();
    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    private int room_id;
    private int user_id;
//    private String nickname;

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(@PathParam("room")int room,Session session){
        this.session = session;
        this.room_id = room;
        if(webSocketListMap.get(room_id)==null) {  //webSocketSet不存在
//        	 CopyOnWriteArraySet<ChatTopicID> webSocketSet = new CopyOnWriteArraySet<ChatTopicID>();
        	webSocketListMap.put(room_id, new CopyOnWriteArraySet<ChatTopicID>());
        }
        webSocketListMap.get(room_id).add(this);
        addOnlineCount();           //在线数加1
//        setId();
        System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(){
    	webSocketListMap.get(room_id).remove(this);
        subOnlineCount();           //在线数减1
        System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     */
    
    @OnMessage
    public void onMessage(String str,Session session) {
        System.out.println("来自客户端的消息:" + str);
        String[] strs = str.split(">");
        user_id = 0;
        try {
        	user_id = Integer.valueOf(strs[0]);
        }
        catch(Exception e) {
        	e.printStackTrace();
        	return;
        }
        String verify = strs[1];
        String message = "";
        message = strs[2];
        for(int i=3;i<strs.length;i++) {
        	message = message + ">"+ strs[i];
        }
        String v_md5 = MD5.code(VerifySource.get(user_id + ""));
        if(!v_md5.equals(verify)) {
        	return;
        }
        
        User user = new User();
        user.setUserID(user_id);
        UserDAO userdao = new UserDAO();
        user = userdao.findNickNameByID(user);
        String nickname = user.getUserNickname();
        
        String time = "";
        LocalDateTime date = LocalDateTime.now();
        time = time + fillZero(date.getHour());
        time = time + ":" + fillZero(date.getMinute());
        time = time + ":" + fillZero(date.getSecond());
        
        //群发消息
        for(ChatTopicID item: webSocketListMap.get(room_id)){
            try {
//                item.sendMessage(nickname + " > " + message);
//            	System.out.println(message);
                item.sendMessage(time + " [id" + user_id + "]" + nickname + " > " + message);
            }
            catch(IOException e) {
                e.printStackTrace();
                continue;
            }
        }
    }
    
    private String fillZero(int number) {
    	if(number<10) {
    		return "0" + number;
    	}
    	else {
    		return number + "";
    	}
    }

    /**
     * 发生错误时调用
     */
    @OnError
    public void onError(Session session, Throwable error){
        System.out.println("发生错误");
        error.printStackTrace();
    }

    public void sendMessage(String message) throws IOException{
        this.session.getBasicRemote().sendText(message);
        //this.session.getAsyncRemote().sendText(message);
    }
    
    public static synchronized int getIdCount() {
    	return idCount;
    }
    
    public static synchronized void addIdCount() {
    	ChatTopicID.idCount++;
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
    	ChatTopicID.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
    	ChatTopicID.onlineCount--;
    }
}
