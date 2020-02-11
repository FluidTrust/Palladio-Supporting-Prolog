package org.palladiosimulator.supporting.prolog.formatting

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.palladiosimulator.supporting.prolog.model.prolog.Clause
import org.palladiosimulator.supporting.prolog.model.prolog.Comment
import org.palladiosimulator.supporting.prolog.model.prolog.CompoundTerm
import org.palladiosimulator.supporting.prolog.model.prolog.Fact
import org.palladiosimulator.supporting.prolog.model.prolog.List
import org.palladiosimulator.supporting.prolog.model.prolog.Program
import org.palladiosimulator.supporting.prolog.model.prolog.Rule
import org.palladiosimulator.supporting.prolog.model.prolog.directives.Directive
import org.palladiosimulator.supporting.prolog.model.prolog.directives.DirectivesPackage
import org.palladiosimulator.supporting.prolog.model.prolog.directives.PredicateIndicator
import org.palladiosimulator.supporting.prolog.model.prolog.expressions.BinaryExpression
import org.palladiosimulator.supporting.prolog.model.prolog.expressions.LogicalAnd
import org.palladiosimulator.supporting.prolog.model.prolog.expressions.UnaryExpression
import org.palladiosimulator.supporting.prolog.services.PrologGrammarAccess

class PrologFormatter extends AbstractFormatter2 {

	@Inject extension PrologGrammarAccess

	def dispatch void format(Program program, extension IFormattableDocument document) {
		program.clauses.forEach[_format(document)]
	}
	
	def dispatch void format(Clause clause, extension IFormattableDocument document) {
		clause.regionFor.keyword(clauseAccess.fullStopKeyword_0_1).prepend[noSpace].append[newLines = 1]
		clause.format
	}
	
	def dispatch void format(Comment comment, extension IFormattableDocument document) {
		var container = comment.eContainer
		var containmentReference = comment.eContainmentFeature
		var clauses = container.eGet(containmentReference) as java.util.List<EObject>
		var commentIndex = clauses.indexOf(comment)
		if (commentIndex > 0 && !(clauses.get(commentIndex - 1) instanceof Comment)) {
			comment.prepend[newLines = 2; priority = 2] // higher than Clause
		}
		comment.append[noSpace]
	}
	
	def dispatch void format(Directive directive, extension IFormattableDocument document) {
		directive.regionFor.keyword(directiveAccess.leftParenthesisKeyword_2).append[noSpace]
		directive.regionFor.keyword(directiveAccess.colonHyphenMinusKeyword_0).surround[noSpace]
		directive.regionFor.feature(DirectivesPackage.Literals.DIRECTIVE__NAME).surround[noSpace]
		directive.regionFor.keyword(directiveAccess.commaKeyword_4_0).prepend[noSpace].append[space = " "]
		directive.regionFor.keyword(directiveAccess.rightParenthesisKeyword_5).prepend[noSpace]
		directive.predicates.forEach[format]
		directive.predicates.forEach[append[noSpace]]
		directive.append[newLines = 2; priority = 2] // higher than Clause
	}
	
	def dispatch void format(PredicateIndicator predicateIndicator, extension IFormattableDocument document) {
		predicateIndicator.regionFor.keyword(predicateIndicatorAccess.solidusKeyword_1).surround[noSpace]
	}
	
	def dispatch void format(CompoundTerm compoundTerm, extension IFormattableDocument document) {
		compoundTerm.regionFor.keyword(compoundTermAccess.leftParenthesisKeyword_1_0).surround[noSpace]
		compoundTerm.regionFor.keyword(compoundTermAccess.commaKeyword_1_2_0).prepend[noSpace].append[space = " "]
		compoundTerm.regionFor.keyword(compoundTermAccess.rightParenthesisKeyword_1_3).prepend[noSpace]
		compoundTerm.arguments.forEach[format]
		compoundTerm.arguments.forEach[append[noSpace]]
	}
	
	
	def dispatch void format(Fact fact, extension IFormattableDocument document) {
		fact.head.format
	}
	
	def dispatch void format(Rule rule, extension IFormattableDocument document) {
		rule.regionFor.keyword(termClauseAccess.colonHyphenMinusKeyword_1_1_1).prepend[space = " "].append[newLine]
		rule.head.format
		rule.body.format
		interior(
			rule.regionFor.keyword(termClauseAccess.colonHyphenMinusKeyword_1_1_1),
			rule.regionFor.keyword(clauseAccess.fullStopKeyword_0_1)
		)[indent]
		
	}
	
	def dispatch void format(BinaryExpression binaryExpression, extension IFormattableDocument document) {
		binaryExpression.left.format
		binaryExpression.right.format
	}
	
	def dispatch void format(UnaryExpression unaryExpression, extension IFormattableDocument document) {
		unaryExpression.expr.format
	}
	
	def dispatch void format(LogicalAnd logicalAnd, extension IFormattableDocument document) {
		logicalAnd.regionFor.keyword(expression_1000_xfyAccess.commaKeyword_1_1).append[newLine].prepend[noSpace]
		logicalAnd.left.format
		logicalAnd.right.format
	}
	
	def dispatch void format(List list, extension IFormattableDocument document) {
		list.regionFor.keyword(listAccess.leftSquareBracketKeyword_1).append[noSpace]
		list.regionFor.keyword(listAccess.commaKeyword_2_1_0).append[space = " "].prepend[noSpace]
		list.regionFor.keyword(listAccess.commaKeyword_2_2_2_0).append[space = " "].prepend[noSpace]
		list.regionFor.keyword(listAccess.verticalLineKeyword_2_2_0).surround[space = " "]
		list.regionFor.keyword(listAccess.rightSquareBracketKeyword_3).prepend[noSpace]
		list.heads.forEach[format]
		list.tails.forEach[format]
	}

}
