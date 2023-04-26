/* **********************************************
 * Duale Hochschule Baden-Württemberg Karlsruhe
 * Prof. Dr. Jörn Eisenbiegler
 * 
 * Vorlesung Übersetzerbau
 * Praxis X Abstiegsparser
 * - Abstiegsparser
 * 
 * **********************************************
 */

package de.dhbw.compiler.xparser;

public class XParser {

	TokenReader in;
	public XParser(TokenReader in) {
		//TODO Initialization
	}

	Tree parseToken(Token token) {
		int myPosition = in.getPosition();
		if ( in.nextToken()==token) {
			Tree t = new Tree(token);
			t.addLastChild(t);
		}
		in.setPosition(myPosition);
		return null;
	}

	public Tree parseProgram() {
		//TODO Parser
		int myPosition = in.getPosition();
		Tree program, id, semicolon, block, dot, eof;

		//Element::= programm
		if(((program=parseToken(new Token(Token.PROGRAM)))!=null)
			&& ((id=parseToken(new Token(Token.ID)))!=null)
			&& ((semicolon=parseToken(new Token(Token.SEMICOLON)))!=null)
			&& ((block=parseBlock())!=null)
			&& ((dot=parseToken(new Token(Token.DOT)))!=null)
			&& ((eof=parseToken(new Token(Token.EOF)))!=null)){

			Tree tree = new Tree(new Token(Token.APROGRAM));

			tree.addLastChild(program);
			tree.addLastChild(id);
			tree.addLastChild(semicolon);
			tree.addLastChild(block);
			tree.addLastChild(dot);
			tree.addLastChild(eof);

		}

		in.setPosition(myPosition);
		return null;
	}

	public Tree parseBlock(){
		int myPosition = in.getPosition();
		Tree begin, stat, end;
		if(((begin=parseToken(new Token(Token.BEGIN)))!=null
			&& ((stat=parseState()))!=null)
			&& ((end=parseToken(new Token(Token.END)))!=null)){

			Tree tree = new Tree(new Token(Token.BLOCK));
			tree.addLastChild(begin);
			tree.addLastChild(stat);
			tree.addLastChild(end);
		}
		in.setPosition(myPosition);
		return null;
	}

	private Tree parseState() {
		Tree stateSemi;

		Tree tree = new Tree(new Token(Token.STATLIST));
		while((stateSemi = parseStateSemi())!=null){
			tree.addLastChild(stateSemi);
		}
		return tree;
	}

	private Tree parseStateSemi() {
		Tree stat, semi;


	}
}
