-- View: public.processingtransformationplant_vw
--
-- 2019.10.16 - New version required to solve harvesting problem 
-- when Processing Transformation Plant has values
-- in fields beginlifespanversion or endlifespanversion
--

DROP VIEW public.processingtransformationplant_vw;

CREATE VIEW public.processingtransformationplant_vw AS 
 SELECT a.processingtransformationplantdbk, f.miningfeatureoccurrencedbk, 
    '#M4EU.PTP_'::text || a.processingtransformationplantdbk AS processingtransformationplantid, 
    f.inspireid, f.inspirens, f.inspireversionid, f.inspireversionidisvoid, 
    f.inspireversionidvoidreason, a.beginlifespanversion, a.endlifespanversion, 
    'M4EU.PTP.AD_'::text || a.processingtransformationplantdbk AS activitydurationid, 
        CASE
            WHEN a.beginlifespanversion IS NULL THEN 'true'::text
            ELSE NULL::text
        END AS beginlifespanversionisvoid, 
    a.beginlifespanversionvoidreason, 
        CASE
            WHEN a.endlifespanversion IS NULL THEN 'true'::text
            ELSE NULL::text
        END AS endlifespanversionisvoid, 
    a.endlifespanversionvoidreason, a.name, 
    ( SELECT processingtransformationplantstatustype.url
           FROM processingtransformationplantstatustype
          WHERE processingtransformationplantstatustype.processingtransformationplantstatustype::text = a.status::text) AS status, 
    to_char(a.startdate, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS startdate, 
        CASE
            WHEN a.startdate IS NOT NULL THEN 'M4EU.PTP.SD_'::text || a.processingtransformationplantdbk
            ELSE NULL::text
        END AS startdateid, 
        CASE
            WHEN a.startdate IS NULL THEN 'true'::text
            ELSE NULL::text
        END AS startdateisvoid, 
    a.startdatevoidreason, 
    to_char(a.enddate, 'YYYY-MM-DD"T"HH24:MI:SS'::text) AS enddate, 
        CASE
            WHEN a.enddate IS NOT NULL THEN 'M4EU.PTP.ED_'::text || a.processingtransformationplantdbk
            ELSE NULL::text
        END AS enddateid, 
        CASE
            WHEN a.enddate IS NULL THEN 'true'::text
            ELSE NULL::text
        END AS enddateisvoid, 
    a.enddatevoidreason, 
        CASE
            WHEN NOT (EXISTS ( SELECT documentcitation.documentcitationdbk
               FROM documentcitation
              WHERE documentcitation.processingtransformationplantdbk = a.processingtransformationplantdbk)) THEN 'true'::text
            ELSE NULL::text
        END AS sourcereferenceisvoid, 
    a.sourcereferencevoidreason, 
        CASE
            WHEN NOT (EXISTS ( SELECT mine.minedbk
               FROM mine
              WHERE mine.processingtransformationplantdbk = a.processingtransformationplantdbk)) THEN 'true'::text
            ELSE NULL::text
        END AS relatedmineisvoid, 
    a.relatedminevoidreason
   FROM miningfeatureoccurrence_vw f, processingtransformationplant a
  WHERE f.miningfeatureoccurrencedbk = a.miningfeatureoccurrencedbk;

ALTER TABLE public.processingtransformationplant_vw
  OWNER TO m4eu;
