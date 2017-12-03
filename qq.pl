 #!/usr/bin/env perl
 use Mojo::Webqq;
 my ($host,$port,$post_api);
 
 $host = "0.0.0.0"; #发送消息接口监听地址，没有特殊需要请不要修改
 $port = 5000;      #发送消息接口监听端口，修改为自己希望监听的端口
 #$post_api = 'http://xxxx';  #接收到的消息上报接口，如果不需要接收消息上报，可以删除或注释此行
 
 my $client = Mojo::Webqq->new();

 #客户端加载ShowMsg插件，用于打印发送和接收的消息到终端
 $client->load("ShowMsg");
 $client->load("Openqq",data=>{listen=>[{host=>$host,port=>$port}], post_api=>$post_api});

 #设置接收消息事件的回调函数，在回调函数中对消息以相同内容进行回复
 # %replies = ('发包', '包');
$client->on(receive_message=>sub{
    my ($client,$msg)=@_;
    if ($msg->is_at()) {
        if ($msg->content =~ "发包") {
            $msg->reply("包");
        } else {
            $msg->reply("啥？");
        }
    }
    # todo: 发包: http://192.168.1.197/patch.zip 
});

 $client->run();