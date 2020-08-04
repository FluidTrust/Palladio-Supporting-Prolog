package org.palladiosimulator.supporting.prolog.tests

import com.google.common.base.Strings
import com.google.inject.Inject
import java.io.File
import java.nio.charset.StandardCharsets
import java.util.Collections
import org.apache.commons.io.FileUtils
import org.apache.commons.io.IOUtils
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.serializer.ISerializer
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import static org.junit.jupiter.api.Assertions.*
import org.eclipse.xtext.resource.SaveOptions

@ExtendWith(InjectionExtension)
@InjectWith(PrologInjectorProvider)
class PrologFormattingTest {
	
	@Inject extension ISerializer
	
	@Test
	def void testDirectives() {
		"formatter_SubsequentDirectives.pl".testSameAsExpected
	}
	
	protected def testSameAsExpected(String fileName) {
		val path = "testdata/" + fileName
		val model = path.readModel
		val actual = model.serialize(SaveOptions.newBuilder.format.options).replace("\r\n", "\n").trim
		val expected = path.readText.replace("\r\n", "\n").trim
		assertEquals(expected, actual)
	}
	
	protected def readModel(String filename) {
		val modelText = filename.readText.uglifyManySpaces
		val modelInputStream = IOUtils.toInputStream(modelText, StandardCharsets.UTF_8)
		
		val rs = new ResourceSetImpl
		val fileUri = URI.createFileURI(filename)
		val modelResource = rs.createResource(fileUri)
		modelResource.load(modelInputStream, Collections.emptyMap)
		return modelResource.contents.iterator.next
	}
	
	protected def readText(String filename) {
		return FileUtils.readFileToString(new File(filename), StandardCharsets.UTF_8)
	}
	
	private static def uglifyManySpaces(String text) {
		return text.replaceAll("\\s+(?=([^\"]*\"[^\"]*\")*[^\"]*$)", Strings.repeat(" ", 10))
	}
	
}