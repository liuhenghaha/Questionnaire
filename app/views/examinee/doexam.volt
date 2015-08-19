<link rel="stylesheet" type="text/css" href="/css/css/Leo_questions.css" />
<script type="text/javascript" src="/js/demand.js"></script>
<div class="Leo_question_v2" id="Leo_question_v2">
        <!--这一部分是暂停时的下拉框-->
        <div id="Leo_hiden" class="Leo_hiden" style="top:-500px;" >
        <table style="height:100%;width:100%;text-align:center;vertical-align:middle;">
        <tr><td id="Leo_hiden_td" style="font-size:18px;text-align:center;"></td></tr>
        <tr><td id="Leo_hiden_td2"><div id="Leo_hiden_ctrl" style="cursor:pointer;margin-left:45%;width:0;height:0;border-top: 30px solid transparent;border-bottom:30px solid transparent;border-left:50px solid green;" onclick="$('#Leo_hiden').slideUp('fast', function() {});"></div><br /></td></tr></table></div>

        <!--这一部分是指导语部分-->
        <div style="overflow:hidden;width:600px;height:440px;">
        <div style="width:95%;height:410px;margin:0 auto;display:none;font-size:22px;font-family:'微软雅黑';overflow:auto;" id='announce_panel'><p></p></div>
        <div id='do_announce' style="width:100%;height:30px;background-color:#eeed6a;cursor:pointer;text-align:center;font-size:22px;">
            <div style="margin:0 auto;"><!--<img src="/images/down.png" style="height:27px;" />--></div>
        </div>

        <div class="Leo_question_l" style="height:400px;" id="Leo_question_panel">
        <div style='width:95%;height:400px;margin:0 auto;'>

        <!--只需在代码中，对这一部分进行解析，替换，实现题目切换-->
        <div id="title_div" class="Leo_title_text" =''><span></span></div>
        <div id='ans_div' style="overflow:auto;font-family:'微软雅黑';">
        <div> </div>
        </div>
        </div>
        </div>
        </div>
        
        <div id="Leo_control" style="width:600px;height:60px;text-align:center;">
            <table style="width:30%;height:60px;margin:0 auto;"><tr style="width:100%;height:100%;"><td style="width:20%;">
                           <img style="height:40px;display:none;" src="../images/left.png" id="Leo_pageup"/>

                </td><td style="width:20%;">
                            <img style="height:40px" src="../images/pause.png" id="Leo_pause" onclick="$('#Leo_hiden').slideDown('fast', function() {});" />
                </td><td style="width:20%;">
                            <img style="height: 40px;" id="Leo_pagedown" src="../images/right.png" />

                </td><td style="width:20%;">
                            <img style="height: 40px; display: none;" id="Leo_checkup" src="../images/signin.png"  />

                </td><td style="width:20%;">
                            <button style="height: 40px;;" id="Leo_All" value="全选A" />

                </td></tr>
            
            </table>

        </div>

        
    </div>
    <div class="Leo_Timer_v2">
    <div id="time_panel" style="width:100%;height:30px;background-color:#eeed6a;text-align:center;font-size:25px;"></div>

    <div class="clock">
    <ul><li style="font-size:25px;" id="used">已用时</li></ul>
    <ul>
    <li id="hours">00</li>
        <li id="point">:</li>
        <li id="min">00</li>
        <li id="point">:</li>
        <li id="sec">00</li>
    </ul>
    </div>
    
    </div>
    <div class="Leo_question_t_v2">
        
        <div style="overflow:auto;height:340px;">
            <table style="width:92%;text-align:center;vertical-align:middle;table-layout:fixed;margin:0 auto;" id="Leo_question_table" cellspacing="0"></table>
        </div>
    </div>
    
<script type="text/javascript">
 /*定义重要的全局变量*/

var Leo_index_now=0;
var done_index=0;

var questions=new Array();
var description="";
var paper_id_name=new Array("16PF","EPPS","SCL","EPQA","CPI","SPM");
var paper_name=new Array("卡特尔十六种人格因素测验","爱德华个人偏好测试","SCL90测试","爱克森个性问卷成人","青年性格问卷测试","瑞文标准推理测验");
var paper_id_now=0;
var ques_order=new Array();

$(function(){

    $("#Leo_All").click(function(){
        var ans=new Array();
        for(var i=0;i<questions.length;i++){
            ans[i]="a";
        }
        $.cookie("exam_ans"+{{number}},ans.join("|"),{experies:7});
        initCookie(questions.length,"exam_ans"+{{number}});
    });


    Leo_timer_start();
    Leo_initPaperId();
    getpaper(paper_id_now);

     $('#do_announce').click(function(){
        if($("#announce_panel").css('display')=='none'){
            $('#announce_panel').slideDown('fast', function() {});
        }else{
            $('#announce_panel').slideUp('fast', function() {});
        }
        
    });

     $("#Leo_pagedown").click(function(){
        changepage(Leo_index_now+1,true);
     });

     $("#Leo_pageup").click(function(){
         changepage(Leo_index_now-1,true);
     });
});

function Leo_initPaperId(){
    var paper_cookie=$.cookie("paper_id"+{{number}});
    if(!paper_cookie){
        $.cookie("paper_id"+{{number}},0,{expeires:7});
        paper_id_now=0;

    }else{
        paper_id_now=parseInt(paper_cookie);
    }
}


function Leo_initPanel(questionlength) {
        $("#time_panel").html(paper_id_name[paper_id_now]);
         $("#do_announce").children("div").html(paper_name[paper_id_now]);

        $("#Leo_question_table").replaceWith("<table style='width:92%;text-align:center;vertical-align:middle;table-layout:fixed;margin:0 auto;' id='Leo_question_table' cellspacing='0'></table>");

        // $("#Leo_question_table").html("");

        var rows_count = Math.ceil(questionlength/ 5);
            for (var k = 0; k < rows_count; k++) {
                var row_now = document.getElementById("Leo_question_table").insertRow(k);
                if (k < rows_count - 1) {
                    for (var i = 0; i < 5; i++) {
                       set_td(i,k,row_now);
                    }
                    //newdiv.onclick =new Function( "changepage(parseInt(this.innerText)-1)");
                } else {
                    for (var i = 0; i < questionlength- (rows_count - 1) * 5 ; i++) {
                        set_td(i,k,row_now);
                    }
                    for (var i = questionlength - (rows_count - 1) * 5; i < 5; i++) {
                        var cell_now = row_now.insertCell(i);
                    }
                    //newdiv.onclick =new Function( "changepage(parseInt(this.innerText)-1)");
                }
            }
        function set_td(i,k,row_now){
            var cell_now = row_now.insertCell(i);
            var newdiv = document.createElement("div");
            newdiv.style.float = "left";
            newdiv.style.margin = "5px";
            newdiv.style.width = "40px";
            newdiv.style.height = "40px";
            newdiv.id = "newdiv_" + ( 5 * k + i);
            newdiv.name="ques_panel";
            newdiv.style.textAlign = "center";
            newdiv.style.cursor = "pointer";
            newdiv.style.backgroundColor = "gray";
            newdiv.textContent= ( 5 * k + i) + 1 + "";
            newdiv.innerText= ( 5 * k + i) + 1 + "";
            newdiv.style.fontSize = "21px";
            newdiv.tabIndex = "0";
            cell_now.appendChild(newdiv);
            newdiv.onclick=new Function("changepage(parseInt(this.innerText)-1,true);");
        }


    }

function Leo_timer_start(){
    var total_time=0;
    time_play();
    var flag=true;
    function time_play(){
        setTimeout(function(){
            if(flag){
                total_time++;
                seconds=total_time%60;
                minutes=(total_time-seconds)/60%60;
                hour=(total_time-seconds-minutes*60)/60/60;
                $("#sec").html(( seconds < 10 ? "0" : "" ) + seconds);
                $("#min").html(( minutes < 10 ? "0" : "" ) + minutes);
                $("#hours").html(( hour < 10 ? "0" : "" ) + hour);
            }
            time_play();
        },1000)
    }

    $("#Leo_pause").click(function(){
        $("#used").html("暂停");
        flag=false;
    });

    $("#Leo_hiden_ctrl").click(function() {
        /* Act on the event */
         $("#used").html("已用时");
        flag=true;
    });

}

function initTitle(index){

    var option_disp="<div>";
    var  option1="<div class='Leo_ans_div'><div class='Leo_ans_checkdiv'><input name='ans_sel' type='radio' id='123' style='cursor:pointer;'/></div><div class='Leo_ans_checktext'>";
    var option2="</div></div>";

    var title='<span>'+(questions[index].index+1)+"."+questions[index].title+'</span>';
    

    if(paper_id_name[paper_id_now]=="SPM"){
        option_disp="<div>";
        option1="<div class='Leo_ans_div_spm'><div class='Leo_ans_checkdiv'><input name='ans_sel' type='radio' id='123' style='cursor:pointer;'/></div><div class='Leo_ans_checktext' style='width:140px;height:85px;text-align:center;'><img style='height:50px;margin-top:17px;' src='/spmimages/";
        option2=".jpg' /></div></div>";
        title=(questions[index].index+1)+"."+"<img style='height:145px;' src='/spmimages/"+questions[index].title+".jpg' />";

        //title=(questions[index].index+1)+"."+"<img style='height:145px;' src='/spmimages/A1M.jpg' />";

    } 

    var options=questions[index].options.split("|");

    for (var i = 0; i <options.length; i++) {
        option_disp+=option1+options[i]+option2;
        //option_disp+=option1+"A1A1"+option2;
    }
    option_disp+="</div>";
    
    $('#ans_div').children('div').replaceWith(option_disp);
    $('#title_div').html(title);

    $('.Leo_ans_checktext').click(function(){
        var temp=$(this).parent().children('div').children(':radio')[0];
        temp.checked=true;
        doclick();
    });

    $('input').click(function(){
        //var temp=$(this).prop('checked','checked');
        doclick();
    })


    function doclick(){
        
        $('#newdiv_'+index).css('background-color', '#48fffb');
        if(Leo_index_now==done_index&&Leo_index_now!=questions.length-1){
            done_index=Leo_index_now+1;
        }
        if(Leo_index_now==questions.length-1){
            $("#Leo_checkup").css('display','');
            $("#Leo_checkup").unbind("click");
            $("#Leo_checkup").click(function(){
                changepage(questions.length-1,true);
                if(confirm("您确定要提交吗?")){
                   Leo_check();
                }
            })
        } 
        changepage(Leo_index_now+1,true);
    }

    $("#ans_div").css('width','100%');
    var ans_div_height=$("#title_div").outerHeight();
    if(ans_div_height<150){
        $("#ans_div").css('height',400-ans_div_height);
    }else{
        $("#title_div").css('height',150);
        $("#ans_div").css('height',250);
    }
}

function get_ans_str(index){
    var ans_array=$("input");
    var ans="0";
    for(var i=0;i<ans_array.length;i++){
        if(ans_array[i].checked){
            ans=String.fromCharCode(i+97);
            break;
        }

    }
    return ans;
}

function get_ans_array_from_cookie(index,user){
    var ans_cookie=$.cookie(user);
    ans_cookie=ans_cookie.split("|");
    var ret=-1;
   
    if(ans_cookie[index]!="0"){
        ret=ans_cookie[index].charCodeAt()-97;
    }
    return ret;
}

function changepage(newpage,isCookie){
    if(newpage>done_index){
        return;
    }

    if(isCookie){
        var ans_str=get_ans_str(Leo_index_now);
        refreshCookie(Leo_index_now,ans_str,"exam_ans"+{{number}});
    }

   Leo_index_now=newpage;
   document.getElementById("newdiv_"+newpage).focus();
   initTitle(newpage);
   var inputs=$("input");
   var new_ans=get_ans_array_from_cookie(newpage,"exam_ans"+{{number}});
   if(new_ans!=-1){
        inputs[new_ans].checked=true;
   }

   if(newpage==0){
        $('#Leo_pageup').css('display', 'none');
   }else{
        $('#Leo_pageup').css('display', '');
   }
  
    if(newpage==done_index){
        $('#Leo_pagedown').css('display', 'none');
   }else{
        $('#Leo_pagedown').css('display', '');
   }
}

function initCookie_title(ans_cookie){
        var ans_array=ans_cookie.split("|");
            var flag=true;
            for(var i=0;i<ans_array.length;i++){
                if(ans_array[i]=='0'){
                    if(flag){
                        done_index=i;
                        changepage(i,false);
                        flag=false;
                    }
                }else{
                     $("#newdiv_" + i).css('background-color',"#48fffb");
                }
            }
            if(flag){
                done_index=ans_array.length-1;
                $("#Leo_checkup").css('display', '');
                $("#Leo_checkup").unbind("click");
                $("#Leo_checkup").click(function(){
                    changepage(questions.length-1,true);
                    if(confirm("您确定要提交吗?")){
                        Leo_check();
                    }
                })

                changepage(ans_array.length-1,false);
            }
    }

function getpaper(paper_index){

         $.post('/Examinee/getpaper', {'paper_name':paper_id_name[paper_index]}, function(data) {
            if(data.no_ques){
                if(paper_id_now<5){
                    paper_id_now++;
                    $.cookie("paper_id"+{{number}},paper_id_now,{experies:7});
                    getpaper(paper_id_now);
                    return;
                }else{
                   ans_complete();
                   return;
                }
            }
         $("#Leo_hiden_td").html("点击进行"+paper_name[paper_id_now]+"的答题");
         $('#Leo_hiden').slideDown('fast', function() {});    //默认设定是题目间的跳转不暂停计时，这个过程被认为是正常的答题过程！！！
         questions=data.question;
         description=data.description;
         ques_order=data.order;
         Leo_initPanel(questions.length);
        initCookie(questions.length,"exam_ans"+{{number}});
        $('#announce_panel').children('p').replaceWith("<p>"+description+"</p>");
     });
}

function Leo_check(){
    $.post('/Examinee/getExamAnswer',{"answer":$.cookie("exam_ans"+{{number}}),"paper_name":paper_id_name[paper_id_now],"order":ques_order}, function(data) {
                            if(data.flag){
                                if(paper_id_now<5){
                                    alert("提交成功！");
                                    paper_id_now++;
                                    done_index=0;
                                    $("#Leo_checkup").css("display","none");
                                    $.cookie("paper_id"+{{number}},paper_id_now,{experies:7});
                                    $.cookie("exam_ans"+{{number}},"",{expires:-1});
                                    getpaper(paper_id_now);
                                }else{
                                    ans_complete();
                                    return;
                                }
                              }else{
                                    alert("提交出错，请联系管理员！");
                              }
                        });

}

function ans_complete(){
    alert("提交成功!您已完成全部题目的作答，谢谢您的配合。\n点击‘确定’退出系统。");
    $.cookie("paper_id"+{{number}},"",{experies:-1});
    $.cookie("exam_ans"+{{number}},"",{expires:-1});
    window.location.href="/"
}
</script>