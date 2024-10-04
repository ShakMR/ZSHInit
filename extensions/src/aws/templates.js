export const TEMPLATES = {
  button: `
<div>
    <button class="roleButton" id="{{roleId}}" style="background-color:{{bgc}}">
        {{stage}}
        <sub>{{name}}</sub>
    </button>
</div>
`,
  accountWrapper: `
<div id="{{service}}-wrapper" class="accountWrapper" style="--n:{{n}}">
    <h2>
        {{service}}
    </h2>
    <div class="rolesContainer">

    </div>
</div>
`
}

export const TemplateNames = {
  button: 'button',
  accountWrapper: 'accountWrapper',
}

export const getTemplateString = (templateName) => {
  return (' ' + TEMPLATES[templateName]).slice(1);
}
