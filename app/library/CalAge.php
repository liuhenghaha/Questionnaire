<?php


class CalAge
{
	public static function calAge1($birthdays,$todays){
		// $today_temp = array();
		// $birthday = $examinee->birthday;
		// $today_temp = explode(' ',$examinee->last_login);
		// $today = $today_temp[0];
		// $startdate=strtotime("$birthday");
		// $enddate=strtotime("$today");
		// echo $enddate-$startdate;
		// $days=round(($enddate-$startdate)/3600/24) ;
		// echo "<br />";
		// echo $days; //days为得到的天数; 
		// echo "<br />";
	}
	public static function getExaminee($examinee_id){
		$examinee = Examinee::findFirst(array(
            'id=?0',
            'bind'=>array($examinee_id)));
		return $examinee;
	}
	public static function getFactorName($factor_id){
		$factor = Factor::findFirst(array(
            'id=?0',
            'bind'=>array($factor_id)));
		$factor_name = $factor->name;
		return $factor_name;
	}

	public static function getPaperName($paper_id){
		return Paper::findFirst($paper_id)->name;
	}
 
}