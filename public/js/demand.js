﻿// JavaScript source code
function Leo_question(index_i, que, kind, ans) {
    this.index = index_i;
    this.ques = que;
    this.Items;
    var question_panel;
    init();

    return question_panel;


    function init() {

        question_panel = document.createElement("div");
        //question_panel.style.backgroundColor = "green";
        question_panel.style.width = "90%";
        question_panel.style.height = "95%";

        question_panel.style.margin = "0 auto";



        var newspan = document.createElement("span");
        newspan.style.width = "100%";
        newspan.style.height = "80px";
        newspan.innerText = index_i  + "." + que;
        newspan.style.fontWeight = "normal";
        newspan.style.fontSize = "28px";
        newspan.style.display = "block";


        question_panel.appendChild(newspan);

        if (!kind) {
            initRadio();
        } else {
            initCheckBox();
        }

    }


    function initRadio() {
       
			var overdiv=document.createElement("div");
			overdiv.style.overflow="auto";
			overdiv.style.height="330px";
        for (var i = 0; i < ans.length ; i++) {
            var answersdiv = document.createElement("div");
            var newRadio = document.createElement("input");
            newRadio.type = "radio";
            newRadio.name = index_i-1 + "";

            var newspan = document.createElement("span");
            answersdiv.style.width = "100%";
            newspan.style.fontSize = "22px";
            answersdiv.style.height = "30px";
            newspan.innerText = ans[i];
            answersdiv.appendChild(newRadio);
            answersdiv.appendChild(newspan);
            answersdiv.style.cursor = "pointer";
            answersdiv.style.marginTop = "15px";
            answersdiv.onclick = new Function("this.childNodes[0].checked=true;Leo_clickRadio(this.childNodes[0]);");
            answersdiv.onmouseover = new Function("this.style.backgroundColor='silver'");
            answersdiv.onmouseout = new Function("this.style.backgroundColor='white'");
            overdiv.appendChild(answersdiv);
        }

		question_panel.appendChild(overdiv);


    }
    function initCheckBox() {

			var overdiv=document.createElement("div");
			overdiv.style.overflow="auto";
			overdiv.style.height="330px";
        for (var i = 0; i < ans.length ; i++) {
            var answersdiv = document.createElement("div");
            var newRadio = document.createElement("input");
            newRadio.type = "checkbox";
            newRadio.name = index_i + "";

            var newspan = document.createElement("span");
            answersdiv.style.width = "100%";
            newspan.style.fontSize = "22px";
            answersdiv.style.height = "auto";
            newspan.innerText = ans[i];
            answersdiv.appendChild(newRadio);
            answersdiv.appendChild(newspan);
            answersdiv.style.cursor = "pointer";
            answersdiv.style.marginTop = "15px";
            
            answersdiv.onclick = new Function("clickCheckBox(this)");
            answersdiv.onmouseover = new Function("this.style.backgroundColor='silver'");
            answersdiv.onmouseout = new Function("this.style.backgroundColor='white'");
            overdiv.appendChild(answersdiv);
        }
        question_panel.appendChild(overdiv);

    }
}








function Leo_pagedown() {

    if (Leo_now_index == questions.length - 1) {
        Leo_checkcomplete();
    } else if (Leo_now_index < questions.length - 1) {

        changepage(Leo_now_index + 1);
    }

   
    //这里答题希望一套一套来答，还是提示只出现一次


}





function Leo_pageup() {

    if (Leo_now_index > 0) {
        changepage(Leo_now_index - 1);
    }
}
function Leo_clickRadio(t) {

    changeColor(t);
    if (Leo_now_index != questions.length - 1) {
        Leo_pagedown();

    } else {

        $("#Leo_pagedown").css('display','');

    }

}

function changeColor(t) {
    $("#newdiv_" + t.name).css('background-color',"green");

    var f = parseInt(t.name);
   
}

function checkcheckbox(name) {
    var b = false;
    var e = document.getElementsByName(name);
    for (var i = 0; i < e.length; i++) {
        if (e[i].checked) {
            b = true;
        }
    }
    if (!b) {
        $("#newdiv_" + name).css('background-color',"gray");
    } else {
        $("#newdiv_" + name).css('background-color',"green");
    }
}

function checkOver3(name) {
    var b = 0;
    var e = document.getElementsByName(name);
    for (var i = 0; i < e.length; i++) {
        if (e[i].checked) {
            b ++;
        }
    }

    if (b >= 3) {
        return false;
    } else {
        return true;
    }
}

function clickCheckBox(t) {
    if (t.childNodes[0].checked) {
        t.childNodes[0].checked = !t.childNodes[0].checked;
        checkcheckbox(t.childNodes[0].name);
    }else if (checkOver3(t.childNodes[0].name)) {
        t.childNodes[0].checked = !t.childNodes[0].checked;
        checkcheckbox(t.childNodes[0].name);
    } else {
        alert("您的选择已超过三项！请确认您的选择！");
    }

    

}

function Leo_checkcomplete() {
        var badques = new Array();
        for (var i = 0; i < questionlength; i++) {
            if ($("newdiv_" + i).style.backgroundColor == "gray") {
                badques.push((i + 1));
            }
        }
        if (badques.length != 0) {
            alert("您的答题是不完整的，其中第" + badques + "题缺少必要的答案！请继续答题！");

            changepage(badques[0] - 1);
        } else {
            var t = confirm("您确定要提交吗？");
            if (t) {
                
                alert("感谢您的配合，我们将在答案提交完毕后，进入问卷调查");
                window.location.href = "testinfo.html";
            }
        }
    }





