module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'politician in Saint Lucia',
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q82955' }, // politician
      P39: {
        value: 'Q21295149',
        qualifiers: {
          P2937: 'Q107486380'
        },
        references: {
          P854: 'http://www.govt.lc/senate',
          P1476: {
            text: 'Web Portal of the Government of Saint Lucia — Members of the Senate',
            language: 'en',
          },
          P813: new Date().toISOString().split('T')[0],
          P407: 'Q1860', // language: English
        },
      }
    }
  }
}
