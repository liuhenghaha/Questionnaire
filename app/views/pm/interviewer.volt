<script type="text/javascript" src="/jqGrid/js/jquery.jqGrid.min.js"></script>
<script type="text/javascript" src="/jqGrid/js/i18n/grid.locale-cn.js"></script>
<script type="text/javascript" src="/js/bootstrap.js"></script>
<script type="text/javascript" src="/lib/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/lib/bootstrap-datetimepicker.js"></script>

<div style="width:100%;height:460px;overflow:hidden;">
    <table id="grid-table"></table>
    <div id="grid-pager"></div>   
     
    <div style="width:100%;height:40px;text-align:center;margin: 5px 10px;">
        <form class="form-inline" method="POST" action="/pm/uploadinterviewer" enctype="multipart/form-data">
            <div class="form-group">
                <a class="btn btn-primary" href="/template/专家导入模板.xls">模板下载</a>
            </div>
            <div class="form-group">
                <input type="file" name="file" input maxlength="100" style="height:30px;cursor:pointer;">
            </div>
            <div class="form-group">
                <button class="btn btn-success" type="submit" >导入</button>
            </div>
            <div class="form-group">
                <a class="btn btn-primary" href="/pm/interviewerExport">导出</a>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">面询完成情况</h4>
            </div>
            <div class="modal-body" style="padding:40px;">
                
            </div>
        <div class="modal-footer">
            <button id="close" class="btn btn-default" data-dismiss="modal">关闭</button>
        </div>
    </div>
</div>

<script type="text/javascript">
    // $("#degree_of_complete").click(function(){
    //     $('.modal-body').html('');
    //     if ($("#degree_of_complete").val == 0) {
    //         $('.modal-body').html(
    //             "<p class=\"bg-danger\" style='padding:20px;'>还未进行过分配！</p>"
    //         );
    //     }else{
    //         $('.modal-body').html(
    //             "<p class=\"bg-danger\" style='padding:20px;'></p>"
    //         );
    //     }
    //     $('#myModal').modal({keyboard:true,});
    // });

    jQuery(function($) {
        var grid_selector = "#grid-table";
        var pager_selector = "#grid-pager";
        
        //resize to fit page size
        $(window).on('resize.jqGrid', function () {
            $(grid_selector).jqGrid( 'setGridWidth', $(".page-content").width() );
        });
        //resize on sidebar collapse/expand
        var parent_column = $(grid_selector).closest('[class*="col-"]');
        $(document).on('settings.ace.jqGrid' , function(ev, event_name, collapsed) {
            if( event_name === 'sidebar_collapsed' || event_name === 'main_container_fixed' ) {
                $(grid_selector).jqGrid( 'setGridWidth', parent_column.width() );
            }
        })

        jQuery(grid_selector).jqGrid({
            subGrid : false,

            url: "/pm/listinterviewer",
            datatype: "json",
            height: '270px',
            shrinkToFit:true,
            forceFit:true,
            autowidth: true,
            colNames:[' ', '专家编号','姓名', '密码', '最后登录时间', '面询完成情况', '查看面巡情况','配置面巡人员'],
            colModel:[
                {name:'myac',index:'', width:70, fixed:true, sortable:false, resize:false,
                    formatter:'actions', 
                    formatoptions:{ 
                        keys:true,                        
                        delOptions:{recreateForm:true,beforeShowForm:beforeDeleteCallback},
                    }},
                {name:'username',index:'username', sorttype:"int",width:80, editable: false,align:'center'},
                {name:'name',index:'name', sortable:true, width:80,sorttype:"string", editable:true,align:'center'},
                {name:'password',index:'password',width:80, sortable:false, sorttype:"string", editable:true,align:'center'},
                {name:'last_login',index:'last_login',width:100, sortable:true, sorttype:"string", editable:false,align:'center'},
                {name:'degree_of_complete',index:'degree_of_complete', sortable:false,width:90, editable: false,align:'center'},
                {name:'check',index:'check', sortable:false,width:90, editable: false,align:'center',
                    formatter:function(cellvalue,options,rowObject){
                        var temp = "<a href='/pm/interviewinfo/"+rowObject.id+"' >查看</a>";
                        return temp;
                    }},
                {name:'user_divide',index:'user_divide', width:90, sortable:false, resize:false,align:'center',
                    formatter:function(cellvalue,options,rowObject){
                        var temp = "<a href='/pm/userdivide/"+rowObject.id+"' >配置</a>";
                        return temp;
                    }}
            ], 
            
            viewrecords : true, 
            rowNum:10,
            rowList:[10,20,30],
            pager : pager_selector,
            altRows: true,
            toppager: false,
            
            multiselect: true,
            //multikey: "ctrlKey",
            multiboxonly: true,
    
            loadComplete : function() {
                var table = this;
                setTimeout(function(){
                    styleCheckbox(table);
                    
                    updateActionIcons(table);
                    updatePagerIcons(table);
                    enableTooltips(table);
                }, 0);
            },
    
            editurl: "/pm/updateinterviewer",//nothing is saved
            caption: "面询专家账号管理",  
            autowidth: true   
        });
        $(window).triggerHandler('resize.jqGrid');//trigger window resize to make the grid get the correct size
    
        //switch element when editing inline
        function aceSwitch( cellvalue, options, cell ) {
            setTimeout(function(){
                $(cell) .find('input[type=checkbox]')
                    .addClass('ace ace-switch ace-switch-5')
                    .after('<span class="lbl"></span>');
            }, 0);
        }
    
        //navButtons
        jQuery(grid_selector).jqGrid('navGrid',pager_selector,
            {   //navbar options
                edit: true,
                editicon : 'ace-icon fa fa-pencil blue',
                add: true,
                addicon : 'ace-icon fa fa-plus-circle purple',
                del: true,
                delicon : 'ace-icon fa fa-trash-o red',
                search: true,
                searchicon : 'ace-icon fa fa-search orange',
                refresh: true,
                refreshicon : 'ace-icon fa fa-refresh green',
                view: true,
                viewicon : 'ace-icon fa fa-search-plus grey',
            },
            {
                //edit record form
                //closeAfterEdit: true,
                //width: 700,
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //new record form
                //width: 700,
                closeAfterAdd: true,
                recreateForm: true,
                viewPagerButtons: false,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar')
                    .wrapInner('<div class="widget-header" />')
                    style_edit_form(form);
                }
            },
            {
                //delete record form
                recreateForm: true,
                beforeShowForm : function(e) {
                    var form = $(e[0]);
                    if(form.data('styled')) return false;
                    
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
                    style_delete_form(form);
                    
                    form.data('styled', true);
                },
                onClick : function(e) {
                    alert(1);
                }
            },
            {
                //search form
                recreateForm: true,
                afterShowSearch: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                    style_search_form(form);
                },
                afterRedraw: function(){
                    style_search_filters($(this));
                }
                ,
                multipleSearch: true,
            },
            {
                //view record form
                recreateForm: true,
                beforeShowForm: function(e){
                    var form = $(e[0]);
                    form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
                }
            }
        )

        function style_edit_form(form) {
            //enable datepicker on "sdate" field and switches for "stock" field
            form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
                .end().find('input[name=stock]')
                    .addClass('ace ace-switch ace-switch-5').after('<span class="lbl"></span>');
                       //don't wrap inside a label element, the checkbox value won't be submitted (POST'ed)
                      //.addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');
    
            //update buttons classes
            var buttons = form.next().find('.EditButton .fm-button');
            buttons.addClass('btn btn-sm').find('[class*="-icon"]').hide();//ui-icon, s-icon
            buttons.eq(0).addClass('btn-primary').prepend('<i class="ace-icon fa fa-check"></i>');
            buttons.eq(1).prepend('<i class="ace-icon fa fa-times"></i>')
            
            buttons = form.next().find('.navButton a');
            buttons.find('.ui-icon').hide();
            buttons.eq(0).append('<i class="ace-icon fa fa-chevron-left"></i>');
            buttons.eq(1).append('<i class="ace-icon fa fa-chevron-right"></i>');       
        }
    
        function style_delete_form(form) {
            var buttons = form.next().find('.EditButton .fm-button');
            buttons.addClass('btn btn-sm btn-white btn-round').find('[class*="-icon"]').hide();//ui-icon, s-icon
            buttons.eq(0).addClass('btn-danger').prepend('<i class="ace-icon fa fa-trash-o"></i>');
            buttons.eq(1).addClass('btn-default').prepend('<i class="ace-icon fa fa-times"></i>')
        }
        
        function style_search_filters(form) {
            form.find('.delete-rule').val('X');
            form.find('.add-rule').addClass('btn btn-xs btn-primary');
            form.find('.add-group').addClass('btn btn-xs btn-success');
            form.find('.delete-group').addClass('btn btn-xs btn-danger');
        }
        function style_search_form(form) {
            var dialog = form.closest('.ui-jqdialog');
            var buttons = dialog.find('.EditTable')
            buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'ace-icon fa fa-retweet');
            buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'ace-icon fa fa-comment-o');
            buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'ace-icon fa fa-search');
        }
        
        function beforeDeleteCallback(e) {
            var form = $(e[0]);
            if(form.data('styled')) return false;
            
            form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
            style_delete_form(form);
            
            form.data('styled', true);
        }
        
        function beforeEditCallback(e) {
            var form = $(e[0]);
            form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
            style_edit_form(form);
        }
    
        function styleCheckbox(table) {

        }
        
        function updateActionIcons(table) {

        }
        function pickDate( cellvalue, options, cell ) {
            setTimeout(function(){
                $(cell) .find('input[type=text]')
                        .datetimepicker({format:'yyyy-mm-dd hh:ii' , autoclose:true}); 
            }, 0);
        }
        //replace icons with FontAwesome icons like above
        function updatePagerIcons(table) {
            var replacement = 
            {
                'ui-icon-seek-first' : 'ace-icon fa fa-angle-double-left bigger-140',
                'ui-icon-seek-prev' : 'ace-icon fa fa-angle-left bigger-140',
                'ui-icon-seek-next' : 'ace-icon fa fa-angle-right bigger-140',
                'ui-icon-seek-end' : 'ace-icon fa fa-angle-double-right bigger-140'
            };
            $('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
                var icon = $(this);
                var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
                
                if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
            })
        }
    
        function enableTooltips(table) {
            $('.navtable .ui-pg-button').tooltip({container:'body'});
            $(table).find('.ui-pg-div').tooltip({container:'body'});
        }
    });
</script>