 #!/usr/bin/env perl
use Mojo::Webqq;
use LWP::Simple;

#Post方法
#use LWP::UserAgent; 
# my $ua = LWP::UserAgent->new;  
# my $req = HTTP::Request->new('POST' => 'http://localhost:8080/webtest/a.jsp');  
# $req->content_type('application/x-www-form-urlencoded');#post请求,如果有发送参数，必须要有这句  
# $req->header('Cookie' => "key1=value1;key2=value2"); #如果想发送cookie，则需这句  
# $req->header('Accept-Language' => 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3');#如需发送请求头，
# $req->content("name=zhangsan&id=123");#发送post的参数  
# my $res = $ua->request($req);  
# print $res->status_line."\n";  
# print $res->as_string();#获取的是原始内容，包括响应头，响应正文  
#$res->content();获取的是响应正文
#$post_api = 'http://xxxx';  #接收到的消息上报接口，如果不需要接收消息上报，可以删除或注释此行  

my ($host,$port,$post_api);
 
 $host = "0.0.0.0"; #发送消息接口监听地址，没有特殊需要请不要修改
 $port = 5000;      #发送消息接口监听端口，修改为自己希望监听的端口
 
 my $client = Mojo::Webqq->new();

 #客户端加载ShowMsg插件，用于打印发送和接收的消息到终端
 $client->load("ShowMsg");
 $client->load("Openqq",data=>{listen=>[{host=>$host,port=>$port}], post_api=>$post_api});

 #设置接收消息事件的回调函数，在回调函数中对消息以相同内容进行回复
 # %replies = ('发包', '包');
$client->on(receive_message=>sub{
    my ($client,$msg)=@_;
    if ($msg->is_at()) {
        if ($msg->content =~ "发包" or $msg->content =~ "打包") {
            $msg->reply("http://192.168.1.197/patch.zip");
        } elsif ($msg->content =~ "构建") {
            my $build_url = "http://localhost:8081/job/ERP(web)/build";
            get($build_url);
            $msg->reply("已开始构建...");
        } else {
            $msg->reply("啥？");
        }
    }
});

 $client->run();