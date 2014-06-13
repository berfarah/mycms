/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */


CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.skin = "bootstrapck";

	config.stylesSet = [
		// Headers
		{ name: 'Header', element: 'h2' },
		{ name: 'Subheader', element: 'h3' },
		{ name: 'Section', element: 'h4' },
		{ name: 'Subsection', element: 'h5' },
		{ name: 'Subtitle', element: 'span', attributes: { 'class': 'subtitle' } },
		{ name: 'Code', element: 'pre' }
	];

	config.plugins.addExternal = 'widget', '/cke/widget';
	config.plugins.addExternal = 'dialog', '/cke/dialog';
	config.plugins.addExternal = 'codesnippet', '/cke/codesnippet';

	config.codeSnippet_theme = 'Railcasts'

	config.toolbar = [
		{ name: 'document', groups: ['mode'], items: ['Source', 'codesnippet'] },
		{ name: 'styles', items: ['Styles'] },
		{ name: 'basicstyles', groups: ['basicstyles', 'cleanup'], items: ['Bold', 'Italic', 'Underline', '-', 'RemoveFormat'] },
		{ name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align'], items: ['BulletedList', 'NumberedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
		{ name: 'links', items: ['Link', 'Unlink', 'Anchor'] },
		{ name: 'insert', items: ['Image', 'Table', 'HorizontalRule', 'PageBreak'] },
		{ name: 'editing', groups: ['find'], items: ['Find', 'Replace'] }
	]
};
