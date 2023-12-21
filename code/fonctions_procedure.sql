-- fonctions et procedures
--1

--2

CREATE OR REPLACE PROCEDURE gen_text_newsletter
(
  index_texte NEWSLETTER.id_news%TYPE,
  texte       NEWSLETTER.texte%TYPE
)
IS

type tsal is table of video.nom_v%type index by binary_integer;
tasal tsal;
i number;
j number;
k number;
l_crlf VARCHAR2(2) := chr(13)||chr(10);
texte_initial NEWSLETTER.texte%TYPE := texte;
Lst_video_week VARCHAR2(100) := 'Liste des sorties de la semaine :';
cursor cur is Select distinct(nom_v)
  from video where (localtimestamp - 7) > date_diffusion;

begin
open cur;
i :=1;
loop
exit when cur%notfound;
fetch cur into tasal(i) ;
i := i + 1;
end loop;
j := i - 1;
k := 1;

loop
exit when k > (j-1);
IF k = 1
THEN
  texte_initial := texte_initial || l_crlf || Lst_video_week;
END IF;
texte_initial := texte_initial || l_crlf || tasal(k);
k := k + 1;
end loop;
INSERT INTO newsletter VALUES (index_texte,texte_initial);
end;
/

-- 3
CREATE OR REPLACE PROCEDURE video_user
(
  user_id UTILISATEUR.id_user%TYPE
)
IS
type tsal is table of video.nom_v%type index by binary_integer;
tasal tsal;
i number;
j number;
k number;
cursor cur is Select distinct(nom_v)
  from video
  INNER JOIN historique on historique.id_video = video.id_video 
  AND historique.id_user = user_id
  AND (historique.id_user in (Select id_user from UTILISATEUR_CATEGORIE))
  AND ((trunc(localtimestamp,'DDD') - trunc(date_visionnage,'DDD'))   < 14)
  group by nom_v;

begin
open cur;
i :=1;
loop
exit when cur%notfound;
fetch cur into tasal(i) ;
i := i + 1;
end loop;
j := i - 1;
k := 1;

loop
exit when k > (j-1);
dbms_output.put_line(tasal(k));
k := k + 1;
end loop;
end;
/
