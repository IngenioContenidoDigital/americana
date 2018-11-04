<?php   

if (!defined('_PS_VERSION_'))
  exit;

class IntegracionSap extends Module
{
    public function __construct(){
        $this->name = 'integracionsap';
        $this->tab = 'others';
        $this->version = '1.0.0';
        $this->author = 'Ingenio Contenido Digital';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_); 
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Integracion Middleware SAP');
        $this->description = $this->l('Modulo para el proceso de intercambio de archivos planos desde y hacia SAP. Desarrollado por Ingenio Contenido Digital (www.ingeniocontenido.co) para Industria Americana de Colchones.');

        $this->confirmUninstall = $this->l('Seguro desea Desinstalar?');
 
        if (!Configuration::get('INTEGRACION_SAP'))      
        $this->warning = $this->l('No se ha suministrado un nombre');
    }
    
    public function install(){
      if (!parent::install()||
    !$this->registerHook('actionOrderStatusPostUpdate') ||
    !Configuration::updateValue('INTEGRACION_SAP', 'www.ingeniocontenido.co'))
        return false;
      return true;
    }
    
    public function uninstall(){
      if (!parent::uninstall())
        return false;
      return true;
    }
    
    public function hookactionOrderStatusPostUpdate($params){
        if($params['newOrderStatus']->id==2){
            $sql="SELECT DISTINCT 
'D006' AS KTOKD_WE,
LPAD(CAST(g.id_gender AS CHAR(10)),4,'0') AS ANRED_WE,
UPPER(CONCAT(c.firstname,' ',c.lastname) ) AS NAME1_WE,
UPPER(CONCAT(a.address1,' ',a.address2)) AS STRAS_WE,
UPPER(ci.ciudad) AS ORT01_WE,
UPPER(ci.codigo_departamento) AS REGIO_WE,
a.phone AS TELF1_WE,
a.phone_mobile AS TELF2_WE,
'Z100000001' AS LZONE_WE,
'01' AS VSBED_WE,
'1' AS TAXKD_WE,
'D005' AS KTOKD,
LPAD(CAST(g.id_gender AS CHAR),4,'0') AS ANRED,
UPPER(CONCAT(c.firstname,' ',c.lastname) ) AS NAME1,
UPPER(c.firstname) AS NAME2,
UPPER(c.lastname) AS NAME3,
UPPER(CONCAT(a.address1,' ',a.address2)) AS STRAS, 
UPPER(ci.ciudad) AS ORT01,
ct.iso_code AS LAND1,
UPPER(ci.codigo_departamento) AS REGIO,
a.phone AS TELF1,
a.phone_mobile AS TELF2,
c.email AS EMAIL,	
c.dni AS STCD1, 
ti.id_dni_type AS STCDT, 
IF(ti.id_dni_type=22,'PJ', 'PN')  AS FITYP,   
IF(ti.id_dni_type=22,'\'', 'X') AS STKZN,  
'0001' AS BRSCH,
CONCAT(SUBSTR(c.birthday,9,2),'/',SUBSTR(c.birthday,6,2)) AS RPMKR,
IF(c.optin=1,LPAD('1',4,'0'),LPAD('2',4,'0')) AS	BRAN1,
'1305058138' AS	AKONT,'Z000' AS ZTERM, '031' AS ZUAWA,'D01' AS	FDGRV,NULL AS	MAHNA,'1001' AS	BUKRS,
NULL AS	WITHT_1,NULL AS	WT_WITHCD_1,NULL AS	WT_AGENT_1,NULL AS	WT_AGTDF_1,NULL AS	WT_AGTDT_1,NULL AS	WITHT_2,NULL AS	WT_WITHCD_2,NULL AS	WT_AGENT_2,	NULL AS WT_AGTDF_2,
NULL AS	WT_AGTDT_2,NULL AS	WITHT_3,NULL AS	WT_WITHCD_3,NULL AS	WT_AGENT_3,NULL AS	WT_AGTDF_3,NULL AS	WT_AGTDT_3,'1' AS	KALKS,'1' AS	VERSG,'01' AS	VSBED,'100' AS	AWAHR,
'X' AS	KZAZU,'9' AS	ANTLF,'1' AS TAXKD,'1100' AS VKORG,'08' AS	VTWEG,'00' AS	SPART,'1907' AS	VKBUR,NULL AS	KUNNR_AG,NULL AS	SUCURSAL ,NULL AS KUNNR_WE, 803 AS KUNNR_VE,
'ES' AS	SPRAS,
CONCAT('WEB_',o.id_order) AS	BSTKD,
DATE_FORMAT(o.date_add,'%Y%m%d') AS	BSTDK,
REPLACE(a.other, '\r\n', ' ') AS	TEXT_ID,
'ZTIA' AS	AUART,'IA' AS	KTGRD,'V13' AS	AUGRU,'2' AS	KVGR1,
NULL AS	EDATU, 
'008' AS VKGRP,NULL AS	AFDAT,NULL AS	FAKWR,
pa.ean13 AS EAN,
LPAD(pa.reference,18,'0') AS	MATNR,
mtf.Denominacion AS	TEXTO,
od.product_quantity AS	ZMENG,
'1100' AS WERKS,'1117' AS	LGORT,
mtf.Tipoposicion AS PSTYV,
'1100' AS VSTEL,'ZR0001' AS ROUTE,
NULL AS	IHREZ_E,
'COP' AS WAERS,NULL AS TEXT_ID_POS,
IF(ISNULL(ccr.id_cart_rule),NULL,'ZDES') AS KSCHA,
IF(ISNULL(ccr.id_cart_rule),NULL,((cr.reduction_percent/100)*mtf.Precio)) AS KBETR, 
NULL AS	KSCHA_2,
NULL AS	KBETR_2,
NULL AS	KSCHA_3,
NULL AS	KBETR_3,
NULL AS	ATWRT,
NULL AS ATWRT,
NULL AS ATWRT,
NULL AS MED_ESP, 
NULL AS	VKAUS
FROM
"._DB_PREFIX_."orders AS o
INNER JOIN "._DB_PREFIX_."customer AS c ON c.id_customer = o.id_customer
INNER JOIN "._DB_PREFIX_."order_detail AS od ON od.id_order=o.id_order 
LEFT JOIN "._DB_PREFIX_."product_attribute AS pa ON pa.id_product_attribute=od.product_attribute_id
LEFT JOIN "._DB_PREFIX_."product_attribute_combination AS pac ON pac.id_product_attribute=pa.id_product_attribute
LEFT JOIN "._DB_PREFIX_."attribute_lang AS al ON al.id_attribute=pac.id_attribute
LEFT JOIN "._DB_PREFIX_."product AS p ON p.id_product=od.product_id 
LEFT JOIN "._DB_PREFIX_."product_lang as pl ON pl.id_product=p.id_product 
INNER JOIN (SELECT EAN, Material, Denominacion, Tipoposicion, Precio FROM "._DB_PREFIX_."materiales AS mt ) AS mtf ON pa.reference=mtf.Material
INNER JOIN "._DB_PREFIX_."address AS a ON o.id_address_delivery = a.id_address
INNER JOIN "._DB_PREFIX_."cities AS ci ON ci.id_cities=a.city
INNER JOIN "._DB_PREFIX_."country AS ct ON a.id_country = ct.id_country 
INNER JOIN "._DB_PREFIX_."gender AS g ON c.id_gender = g.id_gender
INNER JOIN "._DB_PREFIX_."dni_type AS ti ON ti.id_dni_type=c.id_dni_type 
LEFT JOIN "._DB_PREFIX_."cart_cart_rule AS ccr ON ccr.id_cart=o.id_cart 
LEFT JOIN "._DB_PREFIX_."cart_rule AS cr ON cr.id_cart_rule=ccr.id_cart_rule 
WHERE o.current_state=2 AND o.id_order=".$params['id_order']."
 ORDER BY o.id_order";
            $result = Db::getInstance()->executeS($sql);
            
            $file=_PS_MODULE_DIR_.'integracionsap/files/WEB_'.$params['id_order'].'.txt';
            
            //// $encabezado = array('KTOKD_WE','ANRED_WE','NAME1_WE','STRAS_WE','ORT01_WE',
            ////    'REGIO_WE','TELF1_WE','TELF2_WE','LZONE_WE','VSBED_WE','TAXKD_WE','KTOKD','ANRED',
            ////    'NAME1','NAME2','NAME3','STRAS','ORT01','LAND1','REGIO','TELF1','TELF2',
            ////    'EMAIL','STCD1','STCDT','FITYP','STKZN','BRSCH','RPMKR','BRAN1','AKONT',
            ////    'ZTERM','ZUAWA','FDGRV','MAHNA','BUKRS','WITHT_1',
            ////    'WT_WITHCD_1','WT_AGENT_1','WT_AGTDF_1','WT_AGTDT_1','WITHT_2','WT_WITHCD_2','WT_AGENT_2',
            ////    'WT_AGTDF_2','WT_AGTDT_2','WITHT_3','WT_WITHCD_3','WT_AGENT_3','WT_AGTDF_3','WT_AGTDT_3','KALKS','VERSG',
            ////    'VSBED','AWAHR','KZAZU','ANTLF','TAXKD','VKORG','VTWEG','SPART','VKBUR','KUNNR_AG',
            ////    'SUCURSAL','KUNNR_WE','KUNNR_VE','SPRAS','BSTKD','BSTDK','TEXT_ID',
            ////    'AUART','KTGRD','AUGRU','KVGR1','EDATU','VKGRP','AFDAT','FAKWR','EAN','MATNR','TEXTO','ZMENG',
            ////    'WERKS','LGORT','PSTYV','VSTEL','ROUTE','IHREZ_E','WAERS','TEXT_ID_POS','KSCHA','KBETR',
            ////    'KSCHA_2','KBETR_2','KSCHA_3','KBETR_3','ATWRT','ATWRT','ATWRT','MED_ESP','VKAUS');
            $fp = fopen($file, 'wa+');
            ////fputcsv($fp, $encabezado,"\t",'"',"\n");
            foreach ($result as $row) {
                //fputcsv($fp, $row,"\t","");
                $csv = implode("\t", $row);
                $csv = str_replace(PHP_EOL, '', $csv);
                fwrite($fp, $csv."\n");
            }
            fclose($fp);
            $ftp_server='10.21.87.62';
            $ftp_user_name='ingenio';
            $ftp_user_pass='TuYAtr3bU+';
            $ftp_port=22;
            $remote_file='/SAPconnect/Pedidos/WEB_'.$params['id_order'].'.txt';
            ////$file=_PS_MODULE_DIR_.'integracionsap/files/WEB_'.$params['id_order'].'.txt';

            /*try{
                $connection = ssh2_connect($ftp_server, $ftp_port);
                ssh2_auth_password($connection, $ftp_user_name, $ftp_user_pass);
                $resSFTP = ssh2_sftp($connection);
                $resFile = fopen("ssh2.sftp://".(int)$resSFTP.$remote_file, 'w');
                $srcFile = fopen($file, 'r');
                $writtenBytes = stream_copy_to_stream($srcFile, $resFile);
                fclose($resFile);
                fclose($srcFile);
            }catch(Exception $e){
                echo $e->getMessage();
            }*/
            
            
        }
   }
}
