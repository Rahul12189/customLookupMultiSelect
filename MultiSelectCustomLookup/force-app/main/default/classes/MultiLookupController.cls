public without sharing class MultiLookupController {
    public MultiLookupController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName/*,String fieldEmailName*/, String value, List<String> selectedRecId, Boolean useFilterCriteria, String filterField, String filterFieldValue) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();

        if(String.isNotEmpty(value)) {
            String query = 'Select id,';
            if(useFilterCriteria){
                query = query+ fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId ';
                query = query+' and '+filterField+'= \''+filterFieldValue+'\'';

            }else{
                query = query+ fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            }
            system.debug(query);
            String fieldvalue = '';
            String fieldEmail='';
            for(sObject so : Database.Query(query)) {
                fieldvalue = (String)so.get(fieldName);
                //fieldEmail = (String)so.get(fieldEmailName);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id/*,fieldEmail*/));


            }
        }
        return sObjectResultList;
    }

    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public String recMail;


public SObJectResult(String recNameTemp, Id recIdTemp/*, String fieldEmail*/) {
            recName = recNameTemp;
            recId = recIdTemp;
            //recMail = fieldEmail;
        }
        public SObJectResult() {

        }
    }


}

