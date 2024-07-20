import 'package:esmartbazaar/model/receipt/recharge.dart';

class RechargeReceiptHtmlData{

  final RechargeReceiptResponse response;
  RechargeReceiptHtmlData(this.response);

  String printData(){

   return  """
    
    <html xmlns="http://www.w3.org/1999/xhtml">
<head><title>

</title>
    <style type="text/css">
        .tdcolor {
            background-color: #f0f6ff;
            width: 177px;
        }
        .btn {
            font-family: 'Poppins', sans-serif;
            background: #00a65a;
            padding: 4px 20px;
            border: none;
            color: #fff;
            font-size: 12px;
            text-transform: capitalize;
        }
    </style>
   
</head>
<body >
    

        <div style="margin: 2px;">
            <table id="example1" class="" width="300" cellpadding="3"
                cellspacing="3" border="1">
                <tbody>
                    
                            <tr style="background-color: #fff; height: 30px;">
                                <td colspan="2" align="center">
                                    <img src="https://esmartbazaar.in/images/sb_logo.png" style="width: 80%;" />
                                </td>
                            </tr>
                            <tr style="height: 30px;">
                                <td colspan="2" align="center">
                                    <b>Outlet</b> - <b>
                                        ${response.outletName} - ${response.outletMobile}
                                        <b></td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Customer Id</b>
                                </td>
                                <td>
                                    ${response.customerId}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Ref Mobile No</b>
                                </td>
                                <td>
                                    ${response.refMobileNumber}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Operator</b>
                                </td>
                                <td>
                                    ${response.operatorName}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Circle</b>
                                </td>
                                <td>
                                    ${response.circleName}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Recharge Type</b>
                                </td>
                                <td>
                                    ${response.rechargeType}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Date & Time </b>
                                </td>
                                <td>
                                    ${response.date}
                                </td>
                            </tr>
                        
                </tbody>
            </table>
            <table id="Table1" class="" border="1" cellpadding="3"
                cellspacing="0" width="300" cellpadding="5" cellspacing="2">
                <thead>
                    <tr>
                        <th>Tran.Ref.No
                        </th>
                        <th>Operator#
                        </th>
                        <th>Status
                        </th>
                    </tr>
                </thead>
                <tbody>
                    
                            <tr>
                                <td>
                                    ${response.transactionNumber}
                                </td>
                                <td>
                                   ${response.operatorRefNumber}
                                </td>
                                <td>
                                    ${response.transactionStatus}
                                </td>
                            </tr>
                        
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2" align="left">Total Amount :
                        </td>
                        <td colspan="2" align="right" style="font-family: Verdana;">Rs. ${response.amount}
                                                       
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
 
</body>
</html>

    
    """;

  }

}