import org.walkmod.lang.ast.body.FieldDeclaration;
import org.walkmod.lang.ast.body.MethodDeclaration;

type =  root.types[0];

org.walkmod.lang.ast.body.ClassOrInterfaceDeclaration.metaClass.getFields = { ->delegate.members.findAll({it instanceof FieldDeclaration}); }
org.walkmod.lang.ast.body.TypeDeclaration.metaClass.getMethods = { ->delegate.members.findAll({it instanceof MethodDeclaration}); }

