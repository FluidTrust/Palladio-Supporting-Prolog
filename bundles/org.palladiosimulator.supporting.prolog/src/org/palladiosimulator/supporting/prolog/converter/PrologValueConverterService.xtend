package org.palladiosimulator.supporting.prolog.converter

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.common.services.Ecore2XtextTerminalConverters
import org.eclipse.xtext.conversion.ValueConverter

class PrologValueConverterService extends Ecore2XtextTerminalConverters {

	@ValueConverter(rule="PROLOG_STRING")
	def IValueConverter<String> getPrologStringValueConverter() {
		new IValueConverter<String>() {
			override toString(String value) throws ValueConverterException {
				String.format("'%s'", value)
			}

			override toValue(String string, INode node) throws ValueConverterException {
				if (!string.matches("'[^']+'")) {
					throw new ValueConverterException("Prolog strings have to be single quoted but given node is not",
						node, null)
				}
				string.substring(0, string.length - 1)
			}
		}
	}
	
	@ValueConverter(rule="PROLOG_SL_COMMENT")
	def IValueConverter<String> getPrologSingleLineCommentValueConverter() {
		new IValueConverter<String>() {
			
			override toString(String value) throws ValueConverterException {
				String.format("%% %s%n", value) 
			}
			
			override toValue(String string, INode node) throws ValueConverterException {
				if (!string.matches("%([^\\n\\r]*)\\r?\\n")) {
					throw new ValueConverterException("Prolog single line comments have to start with percentage sign and end with a line break",
						node, null)
				}
				string.replaceFirst("% ?([^\\n\\r]*)\\r?\\n", "$1")
			}
			
		}
	}

}
