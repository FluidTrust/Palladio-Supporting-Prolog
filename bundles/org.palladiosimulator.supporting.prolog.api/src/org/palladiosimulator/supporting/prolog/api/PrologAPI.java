package org.palladiosimulator.supporting.prolog.api;

import org.eclipse.xtext.serializer.ISerializer;
import org.palladiosimulator.supporting.prolog.parser.antlr.PrologParser;

public interface PrologAPI {

    PrologParser getParser();
    
    ISerializer getSerializer();
    
}
