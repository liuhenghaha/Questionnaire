<?php
class Test4Controller extends \Phalcon\Mvc\Controller{
	
	public function initialize(){
		$this->response->setHeader("Content-Type", "text/html; charset=utf-8");
	}
	
	public function test5Action(){
		$examinee_id = 12;
		FactorScore::handleFactors($examinee_id);
		
	}
	public function indexAction(){
		$memory_state = BasicScore::start();	
		if($memory_state){
			echo "加载完成";
		}
	}
	public function t1Action(){
		$rt = Factor::queryCache(134);
		print_r($rt);
	}
	public function t2Action(){
		$str = "1|3|4|5|6|7|8|11|12|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|32|33|34|35|36|37|38|39|40|41|42|43|44|46|47|48|49|50|51|52|53|54|55|57|58|59|60|61|62|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|98|99|100|101|102|103|104|105|106|107|109|110|111|112|113|114|115|116|117|118|119|120|121|123|125|126|127|128|129|130|131|132|133|134|135|136|137|139|141|142|143|144|145|146|147|148|149|150|151|152|153|154|155|156|157|158|159|160|161|162|163|164|165|166|167|168|169|170|171|172|173|174|175|176|177|178|179|180|181|182|183|184|185|186|187|188|189|190|191|192|193|194|195|196|197|198|199|201|202|203|204|205|206|207|208|210|211|212|213|214|215|216|217|218|219|220|221|222|223|224|225|226|227|228|229|230";
		$array = explode('|', $str);
		$array_len =  count($array);
		$new = array();
		for($i = 1; $i <=230; $i++ ){
			$new[] = $i;
		}
		for($i = 0; $i <  $array_len; $i++ ){
			if($new[$i] != $array[$i]){
				echo "-";
				echo $new[$i];
				echo "-";
				unset($new[$i]);
				
				$new = array_values($new);
			}
		}
		
	}
}