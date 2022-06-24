import 'dart:convert';
import 'dart:io' as io2;

//import 'package:date_field/date_field.dart';
import 'package:appcotizaciones/src/models/quotation_product_model.dart';
import 'package:appcotizaciones/src/models/report_quotation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Reports {
  void reportsEnableds(ReportDataQuotation rquotation) async {
    if (rquotation.company.strPrintFormat == 'formato_simple') {
      reportsFormatoSimple(rquotation);
    } else {
      if (rquotation.company.strPrintFormat == 'formato_diametros') {
        reportsFormatoDiametros(rquotation);
      }
    }
  }

  void reportsFormatoDiametros(ReportDataQuotation rquotation) async {
    // Create a new PDF document.
    //Get external storage directory
    final controller = new MoneyMaskedTextController(
        decimalSeparator: '.', thousandSeparator: ',');
    //final directory = rquotation.directory;
    io2.Directory appDocDirtTemp = await getTemporaryDirectory();
    String tempDirectory = appDocDirtTemp.path;
    //print(tempDirectory);

//Get directory path
    final path = rquotation.path;
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 10;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    //PdfBrush solidBrush = PdfSolidBrush(PdfColor(150, 148, 148));
    Rect bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    //  graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(text: '', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
    //String currentDate = ''; //'DATE ________';

    //print(icono_company + "------------------------------------");
    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBold =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    PdfFont timesRomanDet = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBoldDet =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    String empresa = rquotation.company.strDesCompany!;
    String ruc = rquotation.company.strRucCompany!;
    String image = rquotation.company.str_image!;
    // if (rquotation.codCompany == "1") {
    page.graphics.drawImage(
        PdfBitmap(io2.File('$tempDirectory/$image').readAsBytesSync()),
        Rect.fromLTWH(10, -5, 80, 80));
    // } else {
    //   page.graphics.drawImage(
    //       PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
    //       Rect.fromLTWH(10, -27, 120, 120));
    // }

    // if (_CodCompany == "2") {
    //   page.graphics.drawImage(
    //       PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
    //       Rect.fromLTWH(10, -27, 120, 120));
    // }

    element = PdfTextElement(
        text: empresa,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(text: '$ruc', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.company.strAddress!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.company.strPhone!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    int separacion_inicio = 15;
    int separacion_todos_cab = 2;
    int separacion_todos_det = 10;

    // fecha

    element = PdfTextElement(text: 'Fecha', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds:
            Rect.fromLTWH(15, result.bounds.bottom + separacion_inicio, 0, 0))!;

    DateTime fec =
        DateTime.parse(rquotation.quotationfin.dateQuotation.toString());
    String formattedDate = DateFormat('yyyy-MM-dd').format(fec);

    element = PdfTextElement(text: formattedDate, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // cotizacion

    element = PdfTextElement(text: 'Nro Cotización', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.quotationfin.id.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // ruc cliente

    element = PdfTextElement(text: 'Doc. Fiscal', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.customer.numRucCustomer.toString(),
        font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // razon social

    element = PdfTextElement(text: 'Razon Social', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.customer.strName.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // vendedor

    element = PdfTextElement(text: 'Vendedor', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(text: rquotation.salesperson, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //condicion de pago

    element =
        PdfTextElement(text: 'Condicion de Pago', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.paycondition, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tipo de entrega

    element = PdfTextElement(text: 'Tipo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.deliverytype, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tiempo de entrega

    element =
        PdfTextElement(text: 'Tiempo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.deliverytime, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

/* CREAMOS PDF  */

//Creates a PDF grid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 11);

//Add header to the grid
    grid.headers.add(1);

    grid.repeatHeader = true;

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Nro.';
    header.cells[1].value = 'Codigo';
    header.cells[2].value = 'Descripción de Producto';
    header.cells[3].value = 'Unidad';
    header.cells[4].value = 'Diametro \r\n (MM)';
    header.cells[5].value = 'Diametro Interno  \r\n(MM)';
    header.cells[6].value = 'Largo \r\n (MM)';
    header.cells[7].value = 'Cantidad';
    header.cells[8].value = 'Peso Teorico \r\n (KG)';
    header.cells[9].value = 'Precio Unit.';
    header.cells[10].value = 'Precio Final';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11,
        style: PdfFontStyle.regular);

//Adds cell customizations
    // for (int i = 0; i < header.cells.count; i++) {
    //   if (i == 0 || i == 1) {
    //     header.cells[i].stringFormat = PdfStringFormat(
    //         alignment: PdfTextAlignment.left,
    //         lineAlignment: PdfVerticalAlignment.middle);
    //   } else {
    //     header.cells[i].stringFormat = PdfStringFormat(
    //         alignment: PdfTextAlignment.right,
    //         lineAlignment: PdfVerticalAlignment.middle);
    //   }
    //   header.cells[i].style = headerStyle;
    // }

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    int contador = 0;

    QuotationProduct quotproduct;

    rquotation.listprodquotationfin.forEach((quotprod) {
      quotproduct = quotprod;

      if (contador > 0) {
        row = grid.rows.add();
      }

      row.cells[0].value = (contador + 1).toString();
      row.cells[1].value =
          quotproduct.cod_TiProducts == null ? '' : quotproduct.cod_TiProducts;
      row.cells[2].value = quotproduct.product_name.toString();
      row.cells[3].value = quotproduct.unity_product;
      row.cells[4].value = (double.parse(quotproduct.diameter) % 1 != 0
              ? double.parse(quotproduct.diameter).toStringAsFixed(2)
              : double.parse(quotproduct.diameter).toStringAsFixed(0))
          .toString();
      row.cells[5].value =
          (double.parse(quotproduct.width_internal_diameter.toString()) % 1 != 0
                  ? double.parse(quotproduct.width_internal_diameter.toString())
                      .toStringAsFixed(2)
                  : double.parse(quotproduct.width_internal_diameter.toString())
                      .toStringAsFixed(0))
              .toString(); //quotproduct.width_internal_diameter;
      row.cells[6].value = quotproduct.long;
      row.cells[7].value = quotproduct.quantity;
      row.cells[8].value =
          double.parse(quotproduct.theoretical_weight).toStringAsFixed(2);
      row.cells[9].value =
          (double.parse(quotproduct.unity_price.toString()) % 1 != 0
                  ? double.parse(quotproduct.unity_price.toString())
                      .toStringAsFixed(2)
                  : double.parse(quotproduct.unity_price.toString()))
              .toString();
      row.cells[10].value = quotproduct.sub_total;

      contador = contador + 1;
    });

//Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    // for (int i = 0; i < grid.rows.count; i++) {
    //   PdfGridRow row = grid.rows[i];
    //   for (int j = 0; j < row.cells.count; j++) {
    //     row.cells[j].style = cellStyle;
    //     if (j == 0 || j == 1) {
    //       row.cells[j].stringFormat = PdfStringFormat(
    //           alignment: PdfTextAlignment.left,
    //           lineAlignment: PdfVerticalAlignment.middle);
    //     } else {
    //       row.cells[j].stringFormat = PdfStringFormat(
    //           alignment: PdfTextAlignment.right,
    //           lineAlignment: PdfVerticalAlignment.middle);
    //     }
    //   }
    // }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

    PdfGridBuiltInStyleSettings tableStyleOption =
        PdfGridBuiltInStyleSettings();
    tableStyleOption.applyStyleForBandedRows = true;
    // tableStyleOption.applyStyleForHeaderRow = true;

    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;

    grid.columns[0].width = 30;
    grid.columns[2].width = 200;
    grid.columns[3].width = 50;
    grid.columns[4].width = 60;
    grid.columns[6].width = 60;

    grid.columns[0].format = format;
    grid.columns[1].format = format;
    grid.columns[2].format = format;
    grid.columns[3].format = format;
    grid.columns[4].format = format;
    grid.columns[5].format = format;
    grid.columns[6].format = format;
    grid.columns[7].format = format;
    grid.columns[8].format = format;
    grid.columns[9].format = format;
    grid.columns[10].format = format;

//Apply built-in table style.
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
        settings: tableStyleOption);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    final icon_mod = rquotation.currency == 1 ? "\$" : "S/";

    print(rquotation.quotationfin.total.toString());

    controller
        .updateValue(double.parse(rquotation.quotationfin.subTotal.toString()));
    String subtotal = controller.numberValue.toString();

    controller
        .updateValue(double.parse(rquotation.quotationfin.lgv.toString()));
    String igv = controller.numberValue.toString();

    controller
        .updateValue(double.parse(rquotation.quotationfin.total.toString()));
    String total = controller.numberValue.toString();

    /* comenzamos a preveer desbordamiento */

    int valid = 0;
    int advance = 4;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Observaciones :  ${rquotation.quotationfin.observation.toString()}',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(15, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 6;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Sub Total :                            $icon_mod $subtotal',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    // .drawString(
    //       'Hello world!',
    //       PdfStandardFont(PdfFontFamily.helvetica, 12,
    //           style: PdfFontStyle.bold),
    //       bounds: Rect.fromLTWH(0, 0, 200, 50),
    //       brush: PdfBrushes.red,
    //       pen: PdfPens.blue,
    //       format: PdfStringFormat(alignment: PdfTextAlignment.left));
    String num_igv = (double.parse(rquotation.company.numImpuesto!) * 100)
        .toStringAsFixed(0);
    gridResult.page.graphics.drawString(
        'IGV. $num_igv% :                             $icon_mod $igv',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Total :                                    $icon_mod $total',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    final moneda_mod = rquotation.currencyName;

    gridResult.page.graphics.drawString(
        '(1) Los Precios estan reflejados en $moneda_mod',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 13;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    if (rquotation.company.campo1?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo1} ',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo2?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo2} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo3?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo3} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo4?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo4} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 30;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    String parf0 = "";
    String parf1 = "";
    String parf2 = "";
    String parf3 = "";

    parf0 = "${rquotation.company.campo5}";
    parf1 = "${rquotation.company.campo6} ";
    parf2 = "${rquotation.company.campo7} ";
    parf3 = "${rquotation.company.campo8} ";

    gridResult.page.graphics.drawString(
        parf0, PdfStandardFont(PdfFontFamily.helvetica, 11),
        // brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 14;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf1, PdfStandardFont(PdfFontFamily.helvetica, 11),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 14;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf2, PdfStandardFont(PdfFontFamily.helvetica, 11),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 14;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        parf3, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    //Save the document
    List<int> bytes = document.save();

    //Dispose the document
    document.dispose();

    final name_pdf = rquotation.quotationfin.id == null
        ? 'temporal_name'
        : rquotation.quotationfin.id;

//Create an empty file to write PDF data
    final file = io2.File('$path/$name_pdf.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/$name_pdf.pdf');
  }

  void reportsFormatoSimple(ReportDataQuotation rquotation) async {
    // Create a new PDF document.
    //Get external storage directory
    final controller = new MoneyMaskedTextController(
        decimalSeparator: '.', thousandSeparator: ',');
    //final directory = rquotation.directory;
    io2.Directory appDocDirtTemp = await getTemporaryDirectory();
    String tempDirectory = appDocDirtTemp.path;
    //print(tempDirectory);

//Get directory path
    final path = rquotation.path;
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 10;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    //PdfBrush solidBrush = PdfSolidBrush(PdfColor(150, 148, 148));
    Rect bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);

//Draws a rectangle to place the heading in that region
    //  graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.helvetica, 14);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(text: '', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
    //String currentDate = ''; //'DATE ________';

    //print(icono_company + "------------------------------------");
    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBold =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

    PdfFont timesRomanDet = PdfStandardFont(PdfFontFamily.helvetica, 10);
    PdfFont timesRomanBoldDet =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

    String empresa = "";
    String ruc = "";
    String image = "";

    ruc = rquotation.company.strRucCompany!;
    empresa = rquotation.company.strDesCompany!;
    image = rquotation.company.str_image!;
    // if (rquotation.codCompany == "1") {
    page.graphics.drawImage(
        PdfBitmap(io2.File('$tempDirectory/$image').readAsBytesSync()),
        Rect.fromLTWH(10, -5, 80, 80));
    // } else {
    //   page.graphics.drawImage(
    //       PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
    //       Rect.fromLTWH(10, -27, 120, 120));
    // }

    // if (_CodCompany == "2") {
    //   page.graphics.drawImage(
    //       PdfBitmap(io2.File('$tempDirectory/suminox.png').readAsBytesSync()),
    //       Rect.fromLTWH(10, -27, 120, 120));
    // }

    element = PdfTextElement(
        text: empresa,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(text: '$ruc', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.company.strAddress!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.company.strPhone!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(132, result.bounds.bottom + 5, 0, 0))!;

    int separacion_inicio = 15;
    int separacion_todos_cab = 1;
    int separacion_todos_det = 10;

    // fecha

    element = PdfTextElement(text: 'Fecha', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds:
            Rect.fromLTWH(15, result.bounds.bottom + separacion_inicio, 0, 0))!;

    DateTime fec =
        DateTime.parse(rquotation.quotationfin.dateQuotation.toString());
    String formattedDate = DateFormat('yyyy-MM-dd').format(fec);

    element = PdfTextElement(text: formattedDate, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // cotizacion

    element = PdfTextElement(text: 'Nro Cotización', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.quotationfin.id.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // ruc cliente

    element = PdfTextElement(text: 'Doc. Fiscal', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.customer.numRucCustomer.toString(),
        font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // razon social

    element = PdfTextElement(text: 'Razon Social', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(
        text: rquotation.customer.strName.toString(), font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    // vendedor

    element = PdfTextElement(text: 'Vendedor', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element = PdfTextElement(text: rquotation.salesperson, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //condicion de pago

    element =
        PdfTextElement(text: 'Condicion de Pago', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.paycondition, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tipo de entrega

    element = PdfTextElement(text: 'Tipo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.deliverytype, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

    //tiempo de entrega

    element =
        PdfTextElement(text: 'Tiempo de Entrega', font: timesRomanBoldDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            15, result.bounds.bottom + separacion_todos_cab, 0, 0))!;

    element =
        PdfTextElement(text: rquotation.deliverytime, font: timesRomanDet);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            135, result.bounds.bottom - separacion_todos_det, 0, 0))!;

/* CREAMOS PDF  */

//Creates a PDF grid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 11);

//Add header to the grid
    grid.headers.add(1);

    grid.repeatHeader = true;

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Nro.';
    header.cells[1].value = 'Codigo';
    header.cells[2].value = 'Descripción de Producto';
    header.cells[3].value = 'Unidad';
    // header.cells[4].value = 'Diametro \r\n (MM)';
    // header.cells[5].value = 'Diametro Interno  \r\n(MM)';
    // header.cells[6].value = 'Largo \r\n (MM)';
    header.cells[7].value = 'Cantidad';
    // header.cells[8].value = 'Peso Teorico \r\n (KG)';
    // header.cells[9].value = 'Precio Unit.';
    header.cells[10].value = 'Precio Final';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11,
        style: PdfFontStyle.regular);

//Adds cell customizations
    // for (int i = 0; i < header.cells.count; i++) {
    //   if (i == 0 || i == 1) {
    //     header.cells[i].stringFormat = PdfStringFormat(
    //         alignment: PdfTextAlignment.left,
    //         lineAlignment: PdfVerticalAlignment.middle);
    //   } else {
    //     header.cells[i].stringFormat = PdfStringFormat(
    //         alignment: PdfTextAlignment.right,
    //         lineAlignment: PdfVerticalAlignment.middle);
    //   }
    //   header.cells[i].style = headerStyle;
    // }

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    int contador = 0;

    QuotationProduct quotproduct;

    rquotation.listprodquotationfin.forEach((quotprod) {
      quotproduct = quotprod;

      if (contador > 0) {
        row = grid.rows.add();
      }

      row.cells[0].value = (contador + 1).toString();
      row.cells[1].value =
          quotproduct.cod_TiProducts == null ? '' : quotproduct.cod_TiProducts;
      row.cells[2].value = quotproduct.product_name.toString();
      row.cells[3].value = quotproduct.unity_product;
      // row.cells[4].value = (double.parse(quotproduct.diameter) % 1 != 0
      //         ? double.parse(quotproduct.diameter).toStringAsFixed(2)
      //         : double.parse(quotproduct.diameter).toStringAsFixed(0))
      //     .toString();
      // row.cells[5].value =
      //     (double.parse(quotproduct.width_internal_diameter.toString()) % 1 != 0
      //             ? double.parse(quotproduct.width_internal_diameter.toString())
      //                 .toStringAsFixed(2)
      //             : double.parse(quotproduct.width_internal_diameter.toString())
      //                 .toStringAsFixed(0))
      //         .toString(); //quotproduct.width_internal_diameter;
      // row.cells[6].value = quotproduct.long;
      row.cells[7].value =
          double.parse(quotproduct.quantity!.toString()).toStringAsFixed(0);
      // row.cells[8].value =
      //     double.parse(quotproduct.theoretical_weight).toStringAsFixed(2);
      // row.cells[9].value =
      //     (double.parse(quotproduct.unity_price.toString()) % 1 != 0
      //             ? double.parse(quotproduct.unity_price.toString())
      //                 .toStringAsFixed(2)
      //             : double.parse(quotproduct.unity_price.toString()))
      //         .toString();
      row.cells[10].value =
          double.parse(quotproduct.sub_total.toString()).toStringAsFixed(2);

      contador = contador + 1;
    });

//Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 11);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    // for (int i = 0; i < grid.rows.count; i++) {
    //   PdfGridRow row = grid.rows[i];
    //   for (int j = 0; j < row.cells.count; j++) {
    //     row.cells[j].style = cellStyle;
    //     if (j == 0 || j == 1) {
    //       row.cells[j].stringFormat = PdfStringFormat(
    //           alignment: PdfTextAlignment.left,
    //           lineAlignment: PdfVerticalAlignment.middle);
    //     } else {
    //       row.cells[j].stringFormat = PdfStringFormat(
    //           alignment: PdfTextAlignment.right,
    //           lineAlignment: PdfVerticalAlignment.middle);
    //     }
    //   }
    // }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

    PdfGridBuiltInStyleSettings tableStyleOption =
        PdfGridBuiltInStyleSettings();
    tableStyleOption.applyStyleForBandedRows = true;
    // tableStyleOption.applyStyleForHeaderRow = true;

    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;

    grid.columns[0].width = 30;
    grid.columns[1].width = 50;
    grid.columns[2].width = 400;
    grid.columns[3].width = 50;

    // grid.columns[4].width = 60;
    // grid.columns[6].width = 60;

    grid.columns[0].format = format;
    grid.columns[1].format = format;
    grid.columns[2].format = format;
    grid.columns[3].format = format;
    // grid.columns[4].format = format;
    // grid.columns[5].format = format;
    // grid.columns[6].format = format;
    grid.columns[7].format = format;
    // grid.columns[8].format = format;
    // grid.columns[9].format = format;
    grid.columns[10].format = format;

//Apply built-in table style.
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
        settings: tableStyleOption);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    final icon_mod = rquotation.currency == 1 ? "\$" : "S/";

    print(rquotation.quotationfin.total.toString());

    controller
        .updateValue(double.parse(rquotation.quotationfin.subTotal.toString()));
    String subtotal = controller.numberValue.toString();

    controller
        .updateValue(double.parse(rquotation.quotationfin.lgv.toString()));
    String igv = controller.numberValue.toString();

    controller
        .updateValue(double.parse(rquotation.quotationfin.total.toString()));
    String total = controller.numberValue.toString();

    /* comenzamos a preveer desbordamiento */

    int valid = 0;
    int advance = 4;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    double contamos = (page.getClientSize().height * 0.70).toDouble();

    gridResult.page.graphics.drawString(
        'Observaciones :  ${rquotation.quotationfin.observation.toString()}',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds:
            Rect.fromLTWH(15, gridResult.bounds.bottom + advance, contamos, 0)
        //format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate)
        );

    advance = advance + 6;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Sub Total :                            $icon_mod $subtotal',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    // .drawString(
    //       'Hello world!',
    //       PdfStandardFont(PdfFontFamily.helvetica, 12,
    //           style: PdfFontStyle.bold),
    //       bounds: Rect.fromLTWH(0, 0, 200, 50),
    //       brush: PdfBrushes.red,
    //       pen: PdfPens.blue,
    //       format: PdfStringFormat(alignment: PdfTextAlignment.left));
    String num_igv = (double.parse(rquotation.company.numImpuesto!) * 100)
        .toStringAsFixed(0);
    gridResult.page.graphics.drawString(
        'IGV. $num_igv% :                             $icon_mod $igv',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    gridResult.page.graphics.drawString(
        'Total :                                    $icon_mod $total',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + advance, 0, 0));
    advance = advance + 20;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    // final moneda_mod =
    //     rquotation.currency == 1 ? "dolares americanos" : "soles peruanos";
    final moneda_mod = rquotation.currencyName;
    gridResult.page.graphics.drawString(
        '(1) Los Precios estan reflejados en $moneda_mod',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

    advance = advance + 13;

    if (gridResult.bounds.bottom + advance > page.getClientSize().height - 40 &&
        valid == 0) {
      PdfPage page2 = document.pages.add();
      graphics = page2.graphics;
      bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
      result = element.draw(
          page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
      grid = PdfGrid();
      gridResult = grid.draw(
          page: page2,
          bounds: Rect.fromLTWH(
              0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
          format: layoutFormat)!;
      advance = 0;
    }

    if (rquotation.company.campo1?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo1} ',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo2?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo2} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo3?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo3} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 13;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo4?.trim() != '') {
      gridResult.page.graphics.drawString('${rquotation.company.campo4} ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 30;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    String parf0 = "";
    String parf1 = "";
    String parf2 = "";
    String parf3 = "";

    parf0 = "${rquotation.company.campo5}";
    parf1 = "${rquotation.company.campo6} ";
    parf2 = "${rquotation.company.campo7} ";
    parf3 = "${rquotation.company.campo8} ";

    if (rquotation.company.campo5?.trim() != '') {
      gridResult.page.graphics.drawString(
          parf0, PdfStandardFont(PdfFontFamily.helvetica, 11),
          // brush: PdfSolidBrush(PdfColor(126, 155, 203)),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 14;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo6?.trim() != '') {
      gridResult.page.graphics.drawString(
          parf1, PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
      advance = advance + 14;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo7?.trim() != '') {
      gridResult.page.graphics.drawString(
          parf2, PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));

      advance = advance + 14;

      if (gridResult.bounds.bottom + advance >
              page.getClientSize().height - 40 &&
          valid == 0) {
        PdfPage page2 = document.pages.add();
        graphics = page2.graphics;
        bounds = Rect.fromLTWH(0, -10, graphics.clientSize.width, 30);
        result = element.draw(
            page: page2, bounds: Rect.fromLTWH(10, bounds.top + 0, 0, 0))!;
        grid = PdfGrid();
        gridResult = grid.draw(
            page: page2,
            bounds: Rect.fromLTWH(
                0, result.bounds.bottom + 20, graphics.clientSize.width, 100),
            format: layoutFormat)!;
        advance = 0;
      }
    }

    if (rquotation.company.campo8?.trim() != '') {
      gridResult.page.graphics.drawString(
          parf3, PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + advance, 0, 0));
    }

    //Save the document
    List<int> bytes = document.save();

    //Dispose the document
    document.dispose();

    final name_pdf = rquotation.quotationfin.id == null
        ? 'temporal_name'
        : rquotation.quotationfin.id;

//Create an empty file to write PDF data
    final file = io2.File('$path/$name_pdf.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/$name_pdf.pdf');
  }
}
