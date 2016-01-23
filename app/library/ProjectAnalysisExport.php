<?php
	use PhpOffice\PhpWord\PhpWord;
/**
	 * @usage 十项报表数据统计
	 *
	 */
require_once("../app/classes/PHPExcel.php");

class ProjectAnalysisExport extends \Phalcon\Mvc\Controller{

    public function excelExport($project_id){
        PHPExcel_CachedObjectStorageFactory::cache_in_memory_serialized;
        $objPHPExcel = new PHPExcel();
        set_time_limit(0);
        //获取第一题选项及下属人员id
        $data = new ProjectComData();
        $result = $data->getBaseLevels($project_id);

        //统计
        $objPHPExcel->createSheet(0);
        $objPHPExcel->setActiveSheetIndex(0); //设置第一个内置表
        $objActSheet = $objPHPExcel->getActiveSheet(); // 获取当前活动的表
        $objActSheet->setTitle('统计');
        $this->statisticsExport($result,$objActSheet);
        //打印每个选项对应表
        $i = 1;
        foreach ($result as $key => $value) {
            $objPHPExcel->createSheet(intval($i));   //添加一个表
            $objPHPExcel->setActiveSheetIndex(intval($i));   //设置第2个表为活动表，提供操作句柄
            $objActSheet = $objPHPExcel->getActiveSheet(); // 获取当前活动的表
            $objActSheet->setTitle($key);
            $this->optionExport($value,$objActSheet);
            $i++;
        }
 		
        //导出
        $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel);
        $file_name = './tmp/'.$project_id.'_analysis.xls';
        $objWriter->save($file_name);
        return $file_name;
    }

    public function position($objActSheet, $pos, $h_align='center'){
        $objActSheet->getStyle($pos)->getAlignment()->setHorizontal($h_align);
        $objActSheet->getStyle($pos)->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
        $objActSheet->getStyle($pos.':'.$pos)->getAlignment()->setWrapText(true);
    }
    //统计表
    public function statisticsExport($result,$objActSheet){
        //settings
        $objActSheet->getDefaultRowDimension()->setRowHeight(21);
        $objActSheet->getDefaultColumnDimension()->setWidth(15);
        
        $startRow = 1; 
        $lastRow = 1;
        foreach ($result as $key =>$value) {
            $objActSheet->setCellValue("A".$startRow,$key);
            $this->position($objActSheet, "A".$startRow);
            $startColumn = 'B';
            $lastColumn = 'B';
            foreach ($value as $skey => $svalue) {
                $number = Examinee::findFirst($svalue)->number;
                $objActSheet->setCellValue($startColumn.$startRow,$number);
                $this->position($objActSheet, $startColumn.$startRow);
                $lastColumn = $startColumn;
                $startColumn++;
            }

            $lastRow = $startRow;
            $startRow++;
        }
    }
    //单个选项表
    public function optionExport($value,$objActSheet){
        $i = 0; 
        $result = new ProjectData();
        $start_column = 'D';
        $last = 'D';
        $last_data = null;
        foreach ($value as $skey => $svalue) {
            $data  = array();
            $data  = $result->getindividualComprehensive($svalue);
            if ($i === 0 ) {
                $this->makeTable($data, $objActSheet); 
            }
            $last = $start_column;
            $last_data =  $data;
            $number = Examinee::findFirst($svalue)->number;
            $this->joinTable( $data, $objActSheet, $start_column++, $number);  
            $i ++ ;
        }
        // 计算平均值
        $this->joinAvg($objActSheet, $last_data, 'D', $last );
    }

    public function joinAvg($objActSheet,$data, $startColumn, $endColumn){
        $column_flag = $endColumn;
        $column_flag++;
        $jiange_1 = $column_flag;
        $column_flag++;
        $jiange_2 = $column_flag;
        $column_flag++;
        $objActSheet->getColumnDimension($column_flag)->setWidth(20);
        $startRow = 1;
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $i++;
            if ($i == 1 ){
                $startRow++;
            }
            $startRow++;
            $objActSheet->setCellValue($column_flag.$startRow,'平均分');
            $this->position($objActSheet, $column_flag.$startRow);
            $objActSheet->getStyle($column_flag.$startRow)->getFont()->setBold(true);
            $startRow++;
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                $objActSheet->getStyle($jiange_1.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($jiange_1.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle($jiange_2.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($jiange_2.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $startRow++;
                $index_chosed_detail = $module_detail[$current_index_number];
                foreach ($index_chosed_detail['detail'] as $index_name){
                    $objActSheet->setCellValue($column_flag.$startRow,"=AVERAGE(".$startColumn.$startRow.":".$endColumn.$startRow.')');
                    $objActSheet->getStyle($column_flag.$startRow)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLUE);
                    $this->position($objActSheet, $column_flag.$startRow);
                    $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                    $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB(PHPExcel_Style_Color::COLOR_YELLOW);
                    $startRow++;
                }
                $objActSheet->setCellValue($column_flag.$startRow,"=AVERAGE(".$startColumn.$startRow.":".$endColumn.$startRow.')');
                $objActSheet->getStyle($column_flag.$startRow)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLUE);
                $this->position($objActSheet, $column_flag.$startRow);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB(PHPExcel_Style_Color::COLOR_YELLOW);
                $startRow++;
                $startRow++;
                $objActSheet->getStyle($jiange_1.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($jiange_1.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle($jiange_2.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($jiange_2.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            }
            $startRow++;
        }
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $startRow++;
            $objActSheet->setCellValue($column_flag.$startRow,'评价结果');
            $this->position($objActSheet, $column_flag.$startRow);
            $objActSheet->getStyle($column_flag.$startRow)->getFont()->setBold(true);
            $startRow++;
            $objActSheet->getStyle($jiange_1.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($jiange_1.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle($jiange_2.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($jiange_2.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                $startRow++;
                $index_chosed_detail = $module_detail[$current_index_number];
                $objActSheet->setCellValue($column_flag.$startRow,'');
                $this->position($objActSheet, $column_flag.$startRow);
            }
            $startRow++;
            $objActSheet->getStyle($jiange_1.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($jiange_1.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle($jiange_2.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($jiange_2.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $startRow++;
        }  
    }
    
    public function joinTable(&$data,$objActSheet, $column_flag, $examinee_id){
        $objActSheet->getColumnDimension($column_flag)->setWidth(20);
        $startRow = 1;
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $i++;
            if ($i == 1 ){
                $startRow++;
                $objActSheet->setCellValue($column_flag.$startRow,$examinee_id);
                $this->position($objActSheet, $column_flag.$startRow);
                $objActSheet->getStyle($column_flag.$startRow)->getFont()->setBold(true);
                $objActSheet->getStyle($column_flag.$startRow)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_RED);
            }
            $startRow++;
            $objActSheet->setCellValue($column_flag.$startRow,'综合分');
            $this->position($objActSheet, $column_flag.$startRow);
            $objActSheet->getStyle($column_flag.$startRow)->getFont()->setBold(true);
            $startRow++;
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $startRow++;
                $index_chosed_detail = $module_detail[$current_index_number];
                foreach ($index_chosed_detail['detail'] as $index_name){
                    $objActSheet->setCellValue($column_flag.$startRow,$index_name['score']);
                    $this->position($objActSheet, $column_flag.$startRow);
                    $startRow++;
                }
                //add index score
                $objActSheet->setCellValue($column_flag.$startRow,$index_chosed_detail['score']);
                $this->position($objActSheet, $column_flag.$startRow);
                $startRow++;
                $startRow++;
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            }
            
            
            $startRow++;
        }
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $startRow++;
            $objActSheet->setCellValue($column_flag.$startRow,'综合分');
            $this->position($objActSheet, $column_flag.$startRow);
            $objActSheet->getStyle($column_flag.$startRow)->getFont()->setBold(true);
            $startRow++;
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                $startRow++;
                $index_chosed_detail = $module_detail[$current_index_number];
                $objActSheet->setCellValue($column_flag.$startRow,$index_chosed_detail['score']);
                $this->position($objActSheet, $column_flag.$startRow);
            }
            $startRow++;
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle($column_flag.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $startRow++;
        }   
    }
    public function makeTable(&$data,$objActSheet){
        //settings
        $objActSheet->getDefaultRowDimension()->setRowHeight(15);
        $objActSheet->getColumnDimension('A')->setWidth(30);
        $objActSheet->getColumnDimension('B')->setWidth(20);
        $objActSheet->getColumnDimension('C')->setWidth(15);
        $name_array = array('一','二','三','四');
        $startRow = 1;
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $objActSheet->mergeCells('A'.$startRow.':E'.$startRow);
            $objActSheet->setCellValue('A'.$startRow,$name_array[$i++].'、'.$module_name.'评价指标');
            $this->position($objActSheet, 'A'.$startRow);
            $objActSheet->getRowDimension($startRow)->setRowHeight(30);
            $objActSheet->getStyle('A'.$startRow)->getFont()->setBold(true);
            if ($i == 1 ){
                $startRow++;
                $objActSheet->setCellValue('A'.$startRow,'被试编号');
                $this->position($objActSheet, 'A'.$startRow);
                $objActSheet->getStyle('A'.$startRow)->getFont()->setBold(true);
                $objActSheet->getStyle('A'.$startRow)->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_RED);
            }
            $startRow++;
            $objActSheet->setCellValue('A'.$startRow,'评价指标');
            $this->position($objActSheet, 'A'.$startRow);
            $objActSheet->getStyle('A'.$startRow)->getFont()->setBold(true);
            $objActSheet->setCellValue('B'.$startRow,'组合因素');
            $this->position($objActSheet, 'B'.$startRow);
            $objActSheet->getStyle('B'.$startRow)->getFont()->setBold(true);
            $startRow++;
            
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                $objActSheet->getStyle('A'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('A'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle('B'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('B'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle('C'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('C'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $startRow++;
                $index_chosed_detail = $module_detail[$current_index_number];
                $objActSheet->setCellValue('A'.$startRow,$index_chosed_detail['chs_name']);
                $this->position($objActSheet, 'A'.$startRow,'left');
                $objActSheet->setCellValue('A'.($startRow+1), $index_chosed_detail['count']);
                $this->position($objActSheet, 'A'.($startRow+1),'left');
                foreach ($index_chosed_detail['detail'] as $index_name){
                    $objActSheet->setCellValue('B'.$startRow,$index_name['name']);
                    $this->position($objActSheet, 'B'.$startRow);
                    $startRow++;
                }
                $startRow++;
                $startRow++;
                $objActSheet->getStyle('A'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('A'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle('B'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('B'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
                $objActSheet->getStyle('C'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
                $objActSheet->getStyle('C'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            }
            $startRow++;
        }
        $i = 0;
        foreach ($data as $module_name =>$module_detail ){
            $objActSheet->mergeCells('A'.$startRow.':E'.$startRow);
            $objActSheet->setCellValue('A'.$startRow,$name_array[$i++].'、'.$module_name.'评价指标');
            $this->position($objActSheet, 'A'.$startRow);
            $objActSheet->getRowDimension($startRow)->setRowHeight(30);
            $objActSheet->getStyle('A'.$startRow)->getFont()->setBold(true);
            $startRow++;
            $objActSheet->setCellValue('A'.$startRow,'评价指标');
            $this->position($objActSheet, 'A'.$startRow);
            $objActSheet->getStyle('A'.$startRow)->getFont()->setBold(true);
            $objActSheet->setCellValue('B'.$startRow,'组合因素');
            $this->position($objActSheet, 'B'.$startRow);
            $objActSheet->getStyle('B'.$startRow)->getFont()->setBold(true);
            $startRow++;
            $objActSheet->getStyle('A'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('A'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle('B'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('B'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle('C'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('C'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $index_count = count($module_detail);
            for ($current_index_number = 0; $current_index_number < $index_count; $current_index_number ++ ){
                    $startRow++;
                    $index_chosed_detail = $module_detail[$current_index_number];
                    $objActSheet->setCellValue('A'.$startRow,$index_chosed_detail['chs_name']);
                    $this->position($objActSheet, 'A'.$startRow);
                    $objActSheet->setCellValue('B'.$startRow,$index_chosed_detail['count']);
                    $this->position($objActSheet, 'B'.$startRow);
            }
            $startRow++;
            $objActSheet->getStyle('A'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('A'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle('B'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('B'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $objActSheet->getStyle('C'.$startRow)->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
            $objActSheet->getStyle('C'.$startRow)->getFill()->getStartColor()->setARGB('FFA9A9A9');
            $startRow++;
        }
    }
    
    #辅助方法 --降维
    private function foo($arr, &$rt) {
        if (is_array($arr)) {
            foreach ($arr as $v) {
                if (is_array($v)) {
                    $this->foo($v, $rt);
                } else {
                    $rt[] = $v;
                }
            }
        }
        return $rt;
    }
}