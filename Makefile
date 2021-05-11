# Compilateurs
OCC = ocamlopt
OCL = ocamllex
OCY = ocamlyacc

# Fichiers compilés, à produire pour fabriquer l'exécutable
OBJS = mnylex.cmx mnyast.cmx mnyparse.cmx mnysem.cmx mnyloop.cmx

mnyloop: $(OBJS)
	$(OCC) -o $@ $(OBJS)

# Les cibles auxiliaires
# (note: une cible avec  « :: » peut être étendue par la suite)
clean::
	/bin/rm -f *~ *.cmo *.cmx *.o *.cmi *.cmt *.cmti \
                   mnyparse.ml mnyparse.mli mnylex.ml mnyloop


# Les dépendances
mnyloop.cmx: mnyast.cmi mnyparse.cmi mnylex.cmi

mnylex.cmx: mnyparse.cmi

mnyparse.cmi: mnyast.cmi

mnyparse.cmx: mnyast.cmi

mnysem.cmx: mnyast.cmi

mnyparse.mli: mnyparse.ml

mnyast.cmi: mnyast.cmx

mnylex.cmi: mnylex.cmx

# Générations de fichiers compilés selon leurs extensions (suffixes) :
# .ext1.ext2 : comment passer de foo.ext1 à foo.ext2
.ml.cmx:
	$(OCC) -c $<

.mli.cmi:
	$(OCC) -c $<

.mll.ml:
	$(OCL) $<

.mly.ml:
	$(OCY) $<

# Déclaration de suffixes :
#  - d'abord, on supprime les suffixes connus de make (.c, .o, etc.)
.SUFFIXES:

# - ensuite, on déclare nos suffixes
.SUFFIXES: .ml .mli .mly .mll .cmx .cmi
