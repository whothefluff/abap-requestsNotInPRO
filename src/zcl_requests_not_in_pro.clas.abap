class zcl_requests_not_in_pro definition
                              public
                              create public.

  public section.

    interfaces: if_oo_adt_classrun.

  protected section.

endclass.
class zcl_requests_not_in_pro implementation.

  method if_oo_adt_classrun~main.

    types result type sorted table of trkorr with unique key table_line.

    constants owner type tr_as4user value 'MA_JTORRE'.

    constants transport_of_copies type trfunction value 'T'.

    constants no_parent type strkorr value is initial.

    constants productive_env type trtarsys value 'C3P'.

    select trkorr
      from e070
      where as4user eq @owner
            and trfunction ne @transport_of_copies
            and strkorr eq @no_parent
      into table @data(requests).

    data(result) = value result( ).

    loop at requests reference into data(request).

      data(transport_detail) = value ctslg_cofile( ).

      call function 'TR_READ_GLOBAL_INFO_OF_REQUEST'
        exporting
          iv_trkorr   = request->*-trkorr
        importing
          es_cofile   = transport_detail.

      if not ( line_exists( transport_detail-systems[ systemid = productive_env ] ) ).

        result = value #( base result
                          ( request->*-trkorr ) ).

      endif.

    endloop.

    out->write( |{ lines( result ) } requests found:| ).

    out->write( result ).

  endmethod.

endclass.
